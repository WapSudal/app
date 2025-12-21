import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'first_launch_provider.g.dart';

/// SharedPreferences 인스턴스를 제공하는 provider
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}

/// 첫 실행 여부를 관리하는 provider
@Riverpod(keepAlive: true)
class FirstLaunch extends _$FirstLaunch {
  static const String _key = 'is_first_launch';

  @override
  Future<bool> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    // 값이 없으면 첫 실행(true), 있으면 이미 실행된 적 있음(false)
    return prefs.getBool(_key) ?? true;
  }

  /// 첫 실행이 완료되었음을 표시
  Future<void> markAsCompleted() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_key, false);
    state = const AsyncValue.data(false);
  }
}
