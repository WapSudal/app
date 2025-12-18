/// 애플리케이션 기본 Exception
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => code != null ? '[$code] $message' : message;
}

/// 404 Not Found - 리소스를 찾을 수 없음
class NotFoundException extends AppException {
  NotFoundException(super.message, {super.code = 'NOT_FOUND'});
}

/// 401 Unauthorized - 인증 실패 또는 권한 없음
class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, {super.code = 'UNAUTHORIZED'});
}

/// 400 Bad Request - 잘못된 요청
class BadRequestException extends AppException {
  BadRequestException(super.message, {super.code = 'BAD_REQUEST'});
}

/// 409 Conflict - 중복된 리소스
class ConflictException extends AppException {
  ConflictException(super.message, {super.code = 'CONFLICT'});
}

/// 500 Internal Server Error - 서버 오류
class ServerException extends AppException {
  ServerException(super.message, {super.code = 'SERVER_ERROR'});
}

/// 네트워크 오류
class NetworkException extends AppException {
  NetworkException(super.message, {super.code = 'NETWORK_ERROR'});
}

/// 타임아웃 오류
class TimeoutException extends AppException {
  TimeoutException(super.message, {super.code = 'TIMEOUT'});
}
