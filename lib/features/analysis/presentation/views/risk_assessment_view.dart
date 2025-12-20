import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_bar.dart';
import '../../domain/entities/analysis_entity.dart';
import '../widgets/risk_assessment_content.dart';

/// 위험도 측정 결과 화면 (Analyze-3-1)
class RiskAssessmentView extends StatelessWidget {
  const RiskAssessmentView({super.key, required this.riskAssessment});

  final RiskAssessmentReportEntity riskAssessment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: CustomAppBar(mode: AppBarMode.subpage, title: '위험도 측정'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: RiskAssessmentContent(riskAssessment: riskAssessment),
      ),
    );
  }
}
