import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/storage/secure_storage_provider.dart';
import '../../domain/entities/auth_user_entity.dart';

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
  final SecureStorageHelper _storageHelper;

  AuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required SecureStorageHelper storageHelper,
  }) : _firebaseAuth = firebaseAuth,
       _storageHelper = storageHelper;

  /// Google 계정으로 로그인
  Future<AuthUserEntity> signInWithGoogle() async {
    try {
      // Google Sign-In 플로우 시작
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // Google 인증 정보 획득
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Firebase credential 생성
      // v7 변경사항: accessToken 분리됨. Firebase 로그인은 idToken만으로 가능.
      final credential = GoogleAuthProvider.credential(
        accessToken: null,
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
      await _saveTokens(googleAuth.idToken);

      return _mapUserToEntity(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getFirebaseAuthErrorMessage(e.code), code: e.code);
    } on GoogleSignInException catch (e) {
      throw AuthException(switch (e.code) {
        GoogleSignInExceptionCode.canceled => '로그인이 취소되었습니다.',
        GoogleSignInExceptionCode.interrupted => '로그인에 실패했습니다.',
        _ => '로그인 중 오류가 발생했습니다: ${e.description}',
      }, code: e.code.name);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('로그인 중 오류가 발생했습니다: $e');
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      // Google Sign-In 로그아웃
      await GoogleSignIn.instance.signOut();

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
      await GoogleSignIn.instance.disconnect();

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
  Future<void> _saveTokens(String? idToken) async {
    await _storageHelper.saveTokens(
      // accessToken: null, // 저장하지 않음 (v7에서 획득 방식 변경됨)
      idToken: idToken,
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
      default:
        return '로그인에 실패했습니다. (오류: $code)';
    }
  }
}
