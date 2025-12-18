import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/domain/entity/user_entity.dart';

/// Mock 사용자 데이터 로컬 저장소 키
abstract class _MockUserStorageKeys {
  static const String userData = 'mock_user_data';
}

/// Mock 사용자 로컬 데이터 소스
///
/// SharedPreferences를 사용하여 Mock 사용자 데이터를 영속적으로 저장
/// 실제 API 연동 전까지 프론트엔드 개발용으로 사용
class MockUserLocalDataSource {
  final SharedPreferences _prefs;

  MockUserLocalDataSource({required SharedPreferences prefs}) : _prefs = prefs;

  /// 사용자 데이터 저장
  Future<void> saveUser(UserEntity user) async {
    final Map<String, dynamic> data = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'role': user.role.name,
      'registeredAt': user.registeredAt.toIso8601String(),
    };
    await _prefs.setString(_MockUserStorageKeys.userData, jsonEncode(data));
  }

  /// 저장된 사용자 데이터 조회
  Future<UserEntity?> getUser() async {
    final jsonString = _prefs.getString(_MockUserStorageKeys.userData);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return UserEntity(
        uid: data['uid'] as String,
        email: data['email'] as String,
        displayName: data['displayName'] as String?,
        photoUrl: data['photoUrl'] as String?,
        role: UserRole.values.firstWhere(
          (r) => r.name == data['role'],
          orElse: () => UserRole.generalUser,
        ),
        registeredAt: DateTime.parse(data['registeredAt'] as String),
      );
    } catch (e) {
      // 파싱 실패 시 데이터 삭제
      await clearUser();
      return null;
    }
  }

  /// 가입 여부 확인
  Future<bool> hasUser() async {
    return _prefs.containsKey(_MockUserStorageKeys.userData);
  }

  /// 사용자 데이터 삭제
  Future<void> clearUser() async {
    await _prefs.remove(_MockUserStorageKeys.userData);
  }
}
