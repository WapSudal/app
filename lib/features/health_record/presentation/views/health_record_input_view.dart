import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/app_lined_text_field.dart';
import '../../../../core/presentation/widgets/app_lined_dropdown.dart';
import '../../../../core/presentation/widgets/app_flat_button.dart';
import '../../../../core/presentation/widgets/app_bar.dart';
import '../../../../core/presentation/widgets/dropdown_menu.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/enums/smoking_status.dart';
import '../../../../core/enums/drinking_level.dart';
import '../providers/health_record_input_notifier.dart';
import '../providers/health_record_mutations.dart';
import '../../domain/providers/health_record_usecase_providers.dart';

class HealthRecordInputView extends ConsumerStatefulWidget {
  const HealthRecordInputView({super.key});

  @override
  ConsumerState<HealthRecordInputView> createState() =>
      _HealthRecordInputViewState();
}

class _HealthRecordInputViewState extends ConsumerState<HealthRecordInputView> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _systolicBPController = TextEditingController();
  final _diastolicBPController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _exerciseHoursController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _systolicBPController.dispose();
    _diastolicBPController.dispose();
    _bloodSugarController.dispose();
    _exerciseHoursController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.month}월 ${date.day}일';
  }

  void _handleSave() {
    final inputState = ref.read(healthRecordInputProvider);

    if (!inputState.hasAnyData) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('최소 하나 이상의 정보를 입력해주세요.')));
      return;
    }

    saveHealthRecordMutation.run(ref, (tsx) async {
      final useCase = tsx.get(saveHealthRecordUseCaseProvider);

      await useCase(
        recordedAt: DateTime.now(),
        weight: double.tryParse(inputState.weight),
        height: double.tryParse(inputState.height),
        systolicBP: int.tryParse(inputState.systolicBP),
        diastolicBP: int.tryParse(inputState.diastolicBP),
        bloodSugar: int.tryParse(inputState.bloodSugar),
        smokingStatus: inputState.smokingStatus,
        drinkingLevel: inputState.drinkingLevel,
        exerciseHours: double.tryParse(inputState.exerciseHours),
        memo: inputState.memo.isNotEmpty ? inputState.memo : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputState = ref.watch(healthRecordInputProvider);
    final saveState = ref.watch(saveHealthRecordMutation);

    ref.listen(saveHealthRecordMutation, (previous, next) {
      switch (next) {
        case MutationSuccess():
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('건강 정보가 저장되었습니다.')));
            ref.read(healthRecordInputProvider.notifier).reset();
            context.pop();
          }
        case MutationError(:final error):
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('저장 실패: $error')));
          }
        default:
          break;
      }
    });

    final isLoading = saveState is MutationPending;

    return Scaffold(
      appBar: const CustomAppBar(title: '건강 정보 입력'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // 날짜 표시
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F6FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatDate(DateTime.now()),
                        style: const TextStyle(
                          color: Color(0xFF1E90FF),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 제목
                    Text(
                      '오늘의 건강 기록을\n입력해주세요',
                      style: theme.textTheme.displaySmall,
                    ),
                    const SizedBox(height: 28),

                    // 기본 정보
                    _buildSectionTitle('기본 정보'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AppLinedTextField(
                            label: '체중 (kg)',
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            onChanged: ref
                                .read(healthRecordInputProvider.notifier)
                                .updateWeight,
                            isExpanded: true,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AppLinedTextField(
                            label: '키 (cm)',
                            controller: _heightController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            onChanged: ref
                                .read(healthRecordInputProvider.notifier)
                                .updateHeight,
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppLinedTextField(
                      label: 'BMI (자동 계산)',
                      controller: TextEditingController(
                        text: inputState.bmi != null
                            ? inputState.bmi!.toStringAsFixed(2)
                            : '',
                      ),
                      readOnly: true,
                      enabled: false,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 32),

                    // 혈압/혈당
                    _buildSectionTitle('혈압/혈당'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AppLinedTextField(
                            label: '수축기 혈압 (mmHg)',
                            controller: _systolicBPController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: ref
                                .read(healthRecordInputProvider.notifier)
                                .updateSystolicBP,
                            isExpanded: true,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: AppLinedTextField(
                            label: '이완기 혈압 (mmHg)',
                            controller: _diastolicBPController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: ref
                                .read(healthRecordInputProvider.notifier)
                                .updateDiastolicBP,
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppLinedTextField(
                      label: '혈당 (mg/dL)',
                      controller: _bloodSugarController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: ref
                          .read(healthRecordInputProvider.notifier)
                          .updateBloodSugar,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 32),

                    // 흡연 상태
                    _buildSectionTitle('흡연 상태'),
                    const SizedBox(height: 20),
                    AppLinedDropdown<SmokingStatus>(
                      label: '흡연 여부',
                      value: inputState.smokingStatus,
                      items: SmokingStatus.values
                          .map(
                            (status) => DropdownItem(
                              value: status,
                              label: status.label,
                            ),
                          )
                          .toList(),
                      onChanged: ref
                          .read(healthRecordInputProvider.notifier)
                          .updateSmokingStatus,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 32),

                    // 음주 상태
                    _buildSectionTitle('음주 상태'),
                    const SizedBox(height: 20),
                    AppLinedDropdown<DrinkingLevel>(
                      label: '음주 여부',
                      value: inputState.drinkingLevel,
                      items: DrinkingLevel.values
                          .map(
                            (level) => DropdownItem(
                              value: level,
                              label: '${level.label} - ${level.description}',
                            ),
                          )
                          .toList(),
                      onChanged: ref
                          .read(healthRecordInputProvider.notifier)
                          .updateDrinkingLevel,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 32),

                    // 오늘 운동 시간
                    _buildSectionTitle('오늘 운동 시간'),
                    const SizedBox(height: 20),
                    AppLinedTextField(
                      label: '오늘 운동 시간 (시간)',
                      controller: _exerciseHoursController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      onChanged: ref
                          .read(healthRecordInputProvider.notifier)
                          .updateExerciseHours,
                      isExpanded: true,
                    ),
                    const SizedBox(height: 32),

                    // 추가 메모
                    _buildSectionTitle('추가 메모'),
                    const SizedBox(height: 20),
                    AppLinedTextField(
                      label: '추가 메모',
                      controller: _memoController,
                      onChanged: ref
                          .read(healthRecordInputProvider.notifier)
                          .updateMemo,
                      isExpanded: true,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // 저장 버튼
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AppFlatButton(
                text: '저장',
                onPressed: isLoading ? null : _handleSave,
                isLoading: isLoading,
                isExpanded: true,
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);

    return Text(title, style: theme.textTheme.headlineSmall);
  }
}
