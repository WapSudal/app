import 'package:freezed_annotation/freezed_annotation.dart';

part 'risk_assessment_model.freezed.dart';
part 'risk_assessment_model.g.dart';

/// 위험도 측정 API 응답 모델
@freezed
abstract class RiskAssessmentModel with _$RiskAssessmentModel {
  const factory RiskAssessmentModel({
    required int riskScore,
    required String riskLevel,
    required int strokeProbability,
    required String assessedAt,
    required String nextCheckupRecommended,
    required int rankPercentile,
    required int groupAverageScore,
    required List<RiskFactorModel> riskFactors,
    required String aiRecommendation,
  }) = _RiskAssessmentModel;

  factory RiskAssessmentModel.fromJson(Map<String, dynamic> json) =>
      _$RiskAssessmentModelFromJson(json);
}

/// 위험 요인 API 모델
@freezed
abstract class RiskFactorModel with _$RiskFactorModel {
  const factory RiskFactorModel({
    required String id,
    required String name,
    required String iconType,
    required String currentValue,
    required String targetValue,
  }) = _RiskFactorModel;

  factory RiskFactorModel.fromJson(Map<String, dynamic> json) =>
      _$RiskFactorModelFromJson(json);
}
