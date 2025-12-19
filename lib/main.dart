import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers/shared_preferences_provider.dart';
import 'core/router/router_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/connection/data/providers/connection_providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // SharedPreferences 초기화 (Mock 데이터 저장소)
  final sharedPreferences = await SharedPreferences.getInstance();

  // ProviderContainer 생성 (데이터 초기화용)
  final container = ProviderContainer(
    overrides: [
      // SharedPreferences Provider override
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),
    ],
  );

  // Connection LocalDataSource 초기화 (영속성 데이터 로드)
  final connectionDataSource = container.read(connectionLocalDataSourceProvider);
  await connectionDataSource.initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Stroke Spoiler',
      theme: AppTheme.lightTheme,
      scrollBehavior: const CustomScrollBehavior(),
      routerConfig: router,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('ko', 'KR')],
      builder: (context, child) {
        Widget result = GestureDetector(
          onTap: () {
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.unfocus();
            }
          },
          child: child,
        );

        // 웹에서는 최대 너비 480px로 제한하고 그림자 추가
        if (kIsWeb) {
          result = Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: result,
            ),
          );
        }

        return result;
      },
    );
  }
}
