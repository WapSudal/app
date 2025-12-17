import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_status_entity.freezed.dart';

/// 분석 상태 엔티티
/// 사용자의 건강 기록 수에 따라 분석 가능 여부를 나타냄
@freezed
abstract class AnalysisStatusEntity with _$AnalysisStatusEntity {
  const factory AnalysisStatusEntity({
    /// 분석 가능 여부
    required bool canAnalyze,

    /// 분석에 필요한 최소 기록 수
    required int requiredRecordCount,

    /// 현재 기록 수
    required int currentRecordCount,

    /// 분석 가능까지 필요한 추가 기록 수
    required int recordsNeeded,

    /// 진행률 (0.0 ~ 1.0)
    required double progress,
  }) = _AnalysisStatusEntity;

  const AnalysisStatusEntity._();

  /// 분석 가능 상태인지 확인
  bool get isAnalysisReady => canAnalyze && recordsNeeded <= 0;
}
