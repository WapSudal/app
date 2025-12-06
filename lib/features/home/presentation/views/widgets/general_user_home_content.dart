import 'package:flutter/material.dart';
import 'home_fast_menu_card.dart';
import 'home_no_data_card.dart';
import 'home_splash_card.dart';
import 'home_welcome_card.dart';

/// 일반 사용자 홈 컨텐츠
///
/// Figma 디자인에 맞춘 홈 화면 레이아웃
/// - 스플래시 카드 (첫 방문 시)
/// - 환영 카드 (시간대별 인사)
/// - 데이터 없음 카드
/// - 빠른 메뉴 카드
class GeneralUserHomeContent extends StatelessWidget {
  const GeneralUserHomeContent({
    super.key,
    this.displayName,
    required this.canManageOwnHealth,
  });

  final String? displayName;
  final bool canManageOwnHealth;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F6FB), // dashboard/bg
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // 스플래시 카드 (첫 방문 시)
            HomeSplashCard(
              onInputPressed: () {
                // TODO: 기록 입력 페이지로 이동
              },
            ),
            const SizedBox(height: 8),
            // 환영 카드
            HomeWelcomeCard(displayName: displayName),
            const SizedBox(height: 8),
            // 데이터 없음 카드
            const HomeNoDataCard(),
            const SizedBox(height: 8),
            // 빠른 메뉴 카드
            HomeFastMenuCard(
              onNewDataInput: () {
                // TODO: 새 데이터 입력 페이지로 이동
              },
              onRiskPrediction: () {
                // TODO: 위험도 예측 페이지로 이동
              },
              onFutureSimulation: () {
                // TODO: 미래 예측 시뮬레이션 페이지로 이동
              },
              onContentExplore: () {
                // TODO: 추천 콘텐츠 탐색 페이지로 이동
              },
            ),
          ],
        ),
      ),
    );
  }
}
