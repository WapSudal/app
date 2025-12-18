import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/providers/secure_storage_provider.dart';
import '../../../../core/domain/entities/auth_user_entity.dart';

/// 인증 관련 예외
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException: $message';
}

/// 인증 Remote DataSource
///
/// Firebase Auth + Google Sign-In 실제 호출 담당
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final SecureStorageHelper _storageHelper;

  AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required SecureStorageHelper storageHelper,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn,
       _storageHelper = storageHelper;

  /// Google 계정으로 로그인
  Future<AuthUserEntity> signInWithGoogle() async {
    try {
      // Google Sign-In 플로우 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // 사용자가 로그인 취소
        throw AuthException('로그인이 취소되었습니다.', code: 'cancelled');
      }

      // Google 인증 정보 획득
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase Auth로 로그인
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        throw AuthException('로그인에 실패했습니다.', code: 'no-user');
      }

      // 토큰 저장
      await _saveTokens(googleAuth);

      return _mapUserToEntity(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('로그인 중 오류가 발생했습니다: $e');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      // Google Sign-In 로그아웃
      await _googleSignIn.signOut();

      // Firebase Auth 로그아웃
      await _firebaseAuth.signOut();

      // 저장된 토큰 삭제
      await _storageHelper.clearAllTokens();
    } catch (e) {
      throw AuthException('로그아웃 중 오류가 발생했습니다: $e');
    }
  }

  /// 계정 전환 (disconnect 후 재로그인)
  Future<AuthUserEntity> switchAccount() async {
    try {
      // 기존 Google 계정 연결 해제 (계정 선택 UI 다시 표시하기 위함)
      await _googleSignIn.disconnect();

      // Firebase 로그아웃
      await _firebaseAuth.signOut();

      // 토큰 삭제
      await _storageHelper.clearAllTokens();

      // 새로운 Google 로그인
      return await signInWithGoogle();
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('계정 전환 중 오류가 발생했습니다: $e');
    }
  }

  /// 현재 로그인된 사용자 정보 조회
  Future<AuthUserEntity?> getCurrentUser() async {
    final User? user = _firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    return _mapUserToEntity(user);
  }

  /// 인증 상태 변경 스트림
  Stream<AuthUserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if (user == null) {
        return null;
      }
      return _mapUserToEntity(user);
    });
  }

  /// Firebase User를 AuthUserEntity로 변환
  AuthUserEntity _mapUserToEntity(User user) {
    return AuthUserEntity(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }

  /// 토큰 저장
  Future<void> _saveTokens(GoogleSignInAuthentication auth) async {
    await _storageHelper.saveTokens(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
  }

  /// Firebase Auth 에러 메시지 변환
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return '이미 다른 방법으로 가입된 계정입니다.';
      case 'invalid-credential':
        return '인증 정보가 유효하지 않습니다.';
      case 'operation-not-allowed':
        return 'Google 로그인이 비활성화되어 있습니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다.';
      case 'user-not-found':
        return '사용자를 찾을 수 없습니다.';
      case 'wrong-password':
        return '잘못된 비밀번호입니다.';
      case 'network-request-failed':
        return '네트워크 연결을 확인해주세요.';
      case 'requires-recent-login':
        return '보안을 위해 재로그인이 필요합니다.';
      default:
        return '로그인에 실패했습니다. (오류: $code)';
    }
  }

  /// 계정 삭제
  ///
  /// 친 로그인이 필요할 수 있음 (requires-recent-login 예외)
  Future<void> deleteAccount() async {
    try {
      final User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw AuthException('로그인된 사용자가 없습니다.', code: 'no-user');
      }

      // Google Sign-In 로그아웃
      await _googleSignIn.signOut();

      // Firebase 계정 삭제
      await user.delete();

      // 저장된 토큰 삭제
      await _storageHelper.clearAllTokens();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('계정 삭제 중 오류가 발생했습니다: $e');
    }
  }

  /// 재인증 후 계정 삭제
  ///
  /// Google 재로그인 후 계정 삭제 수행
  Future<void> reauthenticateAndDelete() async {
    try {
      // Google Sign-In 플로우 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw AuthException('재로그인이 취소되었습니다.', code: 'cancelled');
      }

      // Google 인증 정보 획득
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 현재 사용자 재인증
      final User? user = _firebaseAuth.currentUser;

      if (user == null) {
        throw AuthException('로그인된 사용자가 없습니다.', code: 'no-user');
      }

      await user.reauthenticateWithCredential(credential);

      // Google Sign-In 로그아웃
      await _googleSignIn.signOut();

      // Firebase 계정 삭제
      await user.delete();

      // 저장된 토큰 삭제
      await _storageHelper.clearAllTokens();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseAuthErrorMessage(e.code), code: e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('계정 삭제 중 오류가 발생했습니다: $e');
    }
  }
}
