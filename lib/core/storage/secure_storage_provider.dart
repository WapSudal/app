import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

/// Secure Storage 키 상수
abstract class SecureStorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String idToken = 'id_token';
}

/// FlutterSecureStorage 인스턴스 Provider
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}

/// Secure Storage 헬퍼 클래스
@Riverpod(keepAlive: true)
SecureStorageHelper secureStorageHelper(Ref ref) {
  return SecureStorageHelper(ref.watch(secureStorageProvider));
}

/// Secure Storage 토큰 관리 헬퍼
class SecureStorageHelper {
  final FlutterSecureStorage _storage;

  SecureStorageHelper(this._storage);

  // Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: SecureStorageKeys.accessToken);
  }

  Future<void> setAccessToken(String token) async {
    await _storage.write(key: SecureStorageKeys.accessToken, value: token);
  }

  // Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: SecureStorageKeys.refreshToken);
  }

  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: SecureStorageKeys.refreshToken, value: token);
  }

  // ID Token
  Future<String?> getIdToken() async {
    return await _storage.read(key: SecureStorageKeys.idToken);
  }

  Future<void> setIdToken(String token) async {
    await _storage.write(key: SecureStorageKeys.idToken, value: token);
  }

  // 모든 토큰 저장
  Future<void> saveTokens({
    String? accessToken,
    String? refreshToken,
    String? idToken,
  }) async {
    if (accessToken != null) {
      await setAccessToken(accessToken);
    }
    if (refreshToken != null) {
      await setRefreshToken(refreshToken);
    }
    if (idToken != null) {
      await setIdToken(idToken);
    }
  }

  // 모든 토큰 삭제
  Future<void> clearAllTokens() async {
    await _storage.delete(key: SecureStorageKeys.accessToken);
    await _storage.delete(key: SecureStorageKeys.refreshToken);
    await _storage.delete(key: SecureStorageKeys.idToken);
  }

  // 전체 스토리지 클리어
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
