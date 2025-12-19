import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/domain/entities/user_entity.dart';
import 'user_local_datasource.dart';

/// Mock 사용자 데이터 로컬 저장소 키
abstract class _UserStorageKeys {
  static const String users = 'users';
}

/// Mock 사용자 로컬 데이터 소스
///
/// SharedPreferences를 사용하여 Mock 사용자 데이터를 영속적으로 저장
/// 실제 API 연동 전까지 프론트엔드 개발용으로 사용
class UserLocalDataSourceImpl extends UserLocalDataSource {
  final SharedPreferences _prefs;
  final String Function() _getCurrentUserEmail;

  UserLocalDataSourceImpl({
    required SharedPreferences prefs,
    required String Function() getCurrentUserEmail,
  }) : _prefs = prefs,
       _getCurrentUserEmail = getCurrentUserEmail;

  /// 사용자 데이터 저장
  @override
  Future<void> saveUser(UserEntity user) async {
    final Map<String, dynamic> data = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'role': user.role.name,
      'registeredAt': user.registeredAt.toIso8601String(),
    };

    final jsonString = _prefs.getString(_UserStorageKeys.users);

    try {
      final List<dynamic> jsonList = jsonString != null
          ? jsonDecode(jsonString)
          : [];
      // 기존 사용자 데이터 업데이트 또는 새로 추가
      final existingIndex = jsonList.indexWhere(
        (json) => (json as Map<String, dynamic>)['uid'] == user.uid,
      );
      if (existingIndex != -1) {
        jsonList[existingIndex] = data;
      } else {
        jsonList.add(data);
      }
      await _prefs.setString(_UserStorageKeys.users, jsonEncode(jsonList));
    } catch (e) {
      // 파싱 오류 시 새로 저장
      await _prefs.setString(_UserStorageKeys.users, jsonEncode([data]));
    }
  }

  /// 저장된 사용자 데이터 조회
  @override
  Future<UserEntity?> getCurrentUser() async {
    final email = _getCurrentUserEmail();
    final jsonString = _prefs.getString(_UserStorageKeys.users);
    if (jsonString == null) return null;

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final userJson = jsonList.firstWhere(
        (json) => (json as Map<String, dynamic>)['email'] == email,
        orElse: () => null,
      );
      if (userJson == null) return null;

      return UserEntity(
        uid: userJson['uid'] as String,
        email: userJson['email'] as String,
        displayName: userJson['displayName'] as String,
        photoUrl: userJson['photoUrl'] as String?,
        role: UserRole.values.firstWhere(
          (role) => role.name == (userJson['role'] as String),
        ),
        registeredAt: DateTime.parse(userJson['registeredAt'] as String),
      );
    } catch (e) {
      // 파싱 실패 시 데이터 삭제
      await clearUsers();
      return null;
    }
  }

  /// 모든 사용자 데이터 조회
  @override
  Future<List<UserEntity>> getAllUsers() async {
    final jsonString = _prefs.getString(_UserStorageKeys.users);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((userJson) {
        return UserEntity(
          uid: userJson['uid'] as String,
          email: userJson['email'] as String,
          displayName: userJson['displayName'] as String,
          photoUrl: userJson['photoUrl'] as String?,
          role: UserRole.values.firstWhere(
            (role) => role.name == (userJson['role'] as String),
          ),
          registeredAt: DateTime.parse(userJson['registeredAt'] as String),
        );
      }).toList();
    } catch (e) {
      // 파싱 실패 시 빈 리스트 반환
      return [];
    }
  }

  /// 가입 여부 확인
  @override
  Future<bool> hasCurrentUser() async {
    final email = _getCurrentUserEmail();
    final jsonString = _prefs.getString(_UserStorageKeys.users);
    if (jsonString == null) return false;

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.any(
        (json) => (json as Map<String, dynamic>)['email'] == email,
      );
    } catch (e) {
      return false;
    }
  }

  /// 사용자 데이터 삭제
  @override
  Future<void> clearUsers() async {
    await _prefs.remove(_UserStorageKeys.users);
  }
}
