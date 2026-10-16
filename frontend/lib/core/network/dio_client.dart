import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_interceptor.dart';

// ─── SERVER URL CONFIGURATION ──────────────────────────────────────────────
// The app auto-detects the fastest server:
//   1. Tries LAN IP first (very fast, ~5ms)
//   2. Falls back to the deployed server if LAN is unreachable
//
const String _lanUrl = 'http://192.168.1.14:3000/api/v1';
const String _tunnelUrl = 'https://studyai-bxcl.onrender.com/api/v1';

/// Manages base URL with smart auto-detection and server warm-up.
class ServerConfig {
  static final ServerConfig _instance = ServerConfig._internal();
  factory ServerConfig() => _instance;
  ServerConfig._internal();

  String _activeBaseUrl = _tunnelUrl;
  bool _resolved = false;

  String get baseUrl => _activeBaseUrl;

  /// Probes local candidates first (emulator, localhost, LAN) with a short timeout.
  /// If any responds, uses it immediately for zero-latency local development.
  /// Otherwise, falls back to the cloud server and fires a warm-up ping in the background
  /// so Render spins up while the user is looking at onboarding/login without blocking splash.
  Future<void> resolveAndWarm() async {
    if (_resolved) return;

    final probeDio = Dio(BaseOptions(
      connectTimeout: const Duration(milliseconds: 600),
      receiveTimeout: const Duration(milliseconds: 800),
      headers: {'Bypass-Tunnel-Reminder': 'true'},
    ));

    // Candidates: localhost (desktop/web), 10.0.2.2 (Android emulator), Wi-Fi LAN
    final localCandidates = [
      'http://127.0.0.1:3000/api/v1',
      'http://10.0.2.2:3000/api/v1',
      _lanUrl,
    ];

    // Try all local endpoints in parallel
    for (final candidate in localCandidates) {
      try {
        final healthUrl = candidate.replaceAll('/api/v1', '/health');
        final resp = await probeDio.get(healthUrl);
        if (resp.statusCode == 200) {
          _activeBaseUrl = candidate;
          _resolved = true;
          return;
        }
      } catch (_) {
        // Try next candidate
      }
    }

    // Local server not available — use cloud tunnel
    _activeBaseUrl = _tunnelUrl;
    _resolved = true;

    // Fire warm-up ping to cloud server in background (non-blocking)
    // This wakes up Render while the user navigates onboarding/login
    final tunnelHealthUrl = _tunnelUrl.replaceAll('/api/v1', '/health');
    Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      headers: {'Bypass-Tunnel-Reminder': 'true'},
    )).get(tunnelHealthUrl).catchError((_) {
      // Ignored: wake-up probe
      return Response(requestOptions: RequestOptions(path: ''));
    });
  }

  /// Reset so next app launch re-probes
  void reset() => _resolved = false;
}

/// The current base URL (reactive — updates after ServerConfig resolves).
String get baseUrl => ServerConfig().baseUrl;

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;
  final storage = const FlutterSecureStorage();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: _tunnelUrl, // initial default; overridden per-request
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Bypass-Tunnel-Reminder': 'true',
        },
      ),
    );

    // Dynamically set baseUrl from ServerConfig before every request
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.baseUrl = ServerConfig().baseUrl;
        handler.next(options);
      },
    ));

    // Retry interceptor — automatically retries on 502/503 (tunnel flakiness)
    dio.interceptors.add(RetryInterceptor(dio: dio));
    dio.interceptors.add(AuthInterceptor(dio: dio, storage: storage));
  }
}

/// Retries requests that fail with 502 or 503 (common with free tunnels).
class RetryInterceptor extends Interceptor {
  final Dio dio;
  static const int _maxRetries = 2;

  RetryInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    // Only retry on tunnel-related transient errors
    if ((statusCode == 502 || statusCode == 503) && retryCount < _maxRetries) {
      await Future.delayed(Duration(seconds: retryCount + 1)); // backoff

      err.requestOptions.extra['retryCount'] = retryCount + 1;
      try {
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        // Fall through to normal error handling
      }
    }

    return handler.next(err);
  }
}
