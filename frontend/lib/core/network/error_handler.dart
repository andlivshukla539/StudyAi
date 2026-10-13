import 'package:dio/dio.dart';

/// Converts any exception into a clean, user-friendly error message.
/// This is the single source of truth for all error formatting in the app.
String friendlyError(Object error) {
  if (error is DioException) {
    // 1. Server returned a JSON error body with an 'error' field
    if (error.response?.data is Map && error.response?.data['error'] != null) {
      return error.response!.data['error'].toString();
    }

    // 2. Connection / timeout issues
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Please check your network.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond. Please try again.';
      case DioExceptionType.connectionError:
        return 'Cannot reach server. Check your internet connection.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode ?? 0;
        if (code == 401) return 'Session expired. Please log in again.';
        if (code == 403) return 'You don\'t have permission for this action.';
        if (code == 404) return 'The requested resource was not found.';
        if (code == 429) return 'Too many requests. Please wait a moment.';
        if (code >= 500) return 'Server error. Please try again in a moment.';
        return 'Something went wrong (Error $code).';
      default:
        return 'Network error. Please try again.';
    }
  }

  // Non-Dio error: strip noisy class prefixes
  final raw = error.toString();
  if (raw.contains('SocketException')) return 'Cannot reach server. Check your internet connection.';
  if (raw.contains('TimeoutException')) return 'Connection timed out. Please try again.';
  if (raw.contains('FormatException')) return 'Received an invalid response from the server.';

  // Last resort: return the message but cap length
  if (raw.length > 120) return '${raw.substring(0, 117)}...';
  return raw;
}
