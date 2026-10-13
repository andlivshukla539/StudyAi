import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_interceptor.dart';

// ─── SERVER URL CONFIGURATION ──────────────────────────────────────────────
// Priority order:
//   1. LAN IP   — fast, no tunnel overhead, works when phone & laptop share Wi-Fi
//   2. Tunnel   — fallback when firewall blocks the LAN IP
//
// HOW TO GET YOUR LAN IP (permanent fix):
//   1. Open PowerShell and run:  ipconfig
//   2. Look for "Wireless LAN adapter Wi-Fi" → "IPv4 Address" (e.g. 192.168.1.20)
//   3. Replace _lanUrl below with your IP.
//   4. Allow Node through Windows Firewall:
//        - Press Win key → type "Windows Defender Firewall"
//        - Click "Allow an app or feature through Windows Defender Firewall"
//        - Click "Change settings" → "Allow another app" → Browse to:
//            C:\Program Files\nodejs\node.exe   (or wherever your node.exe is)
//        - Check BOTH "Private" and "Public" → OK.
//      OR run this one-liner in an ADMIN PowerShell:
//        New-NetFirewallRule -DisplayName "Node.js" -Direction Inbound -Program "C:\Program Files\nodejs\node.exe" -Action Allow
//   5. After that, your phone can reach your laptop directly — no tunnel needed!
//
const String _lanUrl = 'http://192.168.1.20:3000/api/v1';
const String _tunnelUrl = 'https://studyai-bxcl.onrender.com/api/v1';

// Toggle this to true once you've completed the firewall step above.
const bool _useLanDirectly = false;

const String baseUrl = _useLanDirectly ? _lanUrl : _tunnelUrl;

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
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60), // bumped for AI calls
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Bypass-Tunnel-Reminder': 'true', // Bypasses localtunnel warning page
        },
      ),
    );

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
