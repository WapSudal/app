import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../domain/entities/analysis_entity.dart';
import '../widgets/what_if_simulation_content.dart';

/// What-if 시뮬레이션 화면
///
/// 두 개의 탭을 포함:
/// - 추천 시나리오: AI 추천 시나리오 상세 정보 표시
/// - 전체 시나리오: 그래프 + 시나리오 카드 리스트 표시

class WhatIfSimulationView extends StatelessWidget {
  const WhatIfSimulationView({super.key, required this.simulation});

  final WhatIfSimulationReportEntity simulation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: CustomAppBar(mode: AppBarMode.subpage, title: 'What-if 시뮬레이션'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: WhatIfSimulationContent(simulation: simulation),
      ),
    );
  }
}
