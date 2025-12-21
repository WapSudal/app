import 'package:uuid/uuid.dart';
import '../../domain/repositories/memo_repository.dart';
import '../../domain/entities/memo_entity.dart';
import '../datasources/memo_local_datasource.dart';
import '../models/memo_model.dart';
import '../../../../core/enums/sharing_scope.dart';
import '../../../../core/exceptions/app_exception.dart';
import '../../../connection/domain/repositories/connection_repository.dart';

class MemoRepositoryImpl implements MemoRepository {
  final MemoLocalDataSource _dataSource;
  final ConnectionRepository _connectionRepository;

  MemoRepositoryImpl({
    required MemoLocalDataSource dataSource,
    required ConnectionRepository connectionRepository,
  }) : _dataSource = dataSource,
       _connectionRepository = connectionRepository;

  @override
  Future<void> saveMemo({
    required String patientEmail,
    required String content,
  }) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientEmail: patientEmail,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException('해당 환자의 메모를 작성할 권한이 없습니다.');
    }

    final model = MemoModel(
      id: const Uuid().v4(),
      patientEmail: patientEmail,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
    );

    await _dataSource.saveMemo(model);
  }

  @override
  Future<List<MemoEntity>> getMemosByPatientEmail(
    String patientEmail,
  ) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientEmail: patientEmail,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException('해당 환자의 메모에 접근할 권한이 없습니다.');
    }

    final models = await _dataSource.getMemosByPatientEmail(patientEmail);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deleteMemo({
    required String patientEmail,
    required String memoId,
  }) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientEmail: patientEmail,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException('해당 환자의 메모를 삭제할 권한이 없습니다.');
    }

    await _dataSource.deleteMemo(
      patientEmail: patientEmail,
      memoId: memoId,
    );
  }

  @override
  Future<void> clearMemos(String patientEmail) async {
    // 권한 검증: 환자 데이터 접근 가능 여부 확인
    final canAccess = await _connectionRepository.canAccessPatientData(
      patientEmail: patientEmail,
      requiredScope: SharingScope.full,
    );

    if (!canAccess) {
      throw UnauthorizedException('해당 환자의 메모를 삭제할 권한이 없습니다.');
    }

    await _dataSource.clearMemos(patientEmail);
  }
}
