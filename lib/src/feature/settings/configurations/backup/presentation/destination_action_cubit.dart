import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/destination/backup_destination_kind.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/domain/failure/backup_failure.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/destinations/destination_registry.dart';
import 'package:diary_mobile_client/src/feature/settings/configurations/backup/infrastructure/providers/interfaces/i_backup_local_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;

/// [DestinationActionCubit]의 상태.
///
/// idle / loading / success(message) / failure(message) 4가지로 단순화된다.
class DestinationActionState extends Equatable {
  final bool isWorking;
  final String? successMessage;
  final BackupFailure? failure;

  /// 마지막으로 성공한 destination kind (UI 피드백용)
  final BackupDestinationKind? lastSuccessKind;

  const DestinationActionState({
    this.isWorking = false,
    this.successMessage,
    this.failure,
    this.lastSuccessKind,
  });

  const DestinationActionState.idle() : this();

  DestinationActionState copyWith({
    bool? isWorking,
    String? successMessage,
    bool clearSuccess = false,
    BackupFailure? failure,
    bool clearFailure = false,
    BackupDestinationKind? lastSuccessKind,
    bool clearLastSuccessKind = false,
  }) {
    return DestinationActionState(
      isWorking: isWorking ?? this.isWorking,
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      failure: clearFailure ? null : (failure ?? this.failure),
      lastSuccessKind: clearLastSuccessKind
          ? null
          : (lastSuccessKind ?? this.lastSuccessKind),
    );
  }

  @override
  List<Object?> get props =>
      [isWorking, successMessage, failure, lastSuccessKind];
}

/// 백업 페이지 전용의 가벼운 cubit.
///
/// [BackupBloc]의 책임 범위를 침범하지 않으면서, "DB 파일을 만들고 임의의
/// destination으로 보낸다"는 새로운 흐름을 처리한다.
///
/// 1. [IBackupLocalProvider.exportDriftDatabase]로 임시 백업 파일을 만든다.
/// 2. [BackupDestinationRegistry]에서 해당 [BackupDestinationKind]을 찾는다.
/// 3. `destination.sendFile(path, suggestedName)`을 호출한다.
@injectable
class DestinationActionCubit extends Cubit<DestinationActionState> {
  final IBackupLocalProvider _localProvider;
  final BackupDestinationRegistry _registry;

  DestinationActionCubit(this._localProvider, this._registry)
      : super(const DestinationActionState.idle());

  /// 메시지(성공/실패) 알림 처리가 끝난 뒤 호출하여 상태를 정리한다.
  void clearMessages() {
    emit(state.copyWith(clearSuccess: true, clearFailure: true));
  }

  /// 주어진 [kind]로 DB 백업 파일을 보낸다.
  Future<void> sendToDestination(BackupDestinationKind kind) async {
    emit(state.copyWith(
      isWorking: true,
      clearFailure: true,
      clearSuccess: true,
      clearLastSuccessKind: true,
    ));

    final destination = _registry.findByKind(kind);
    if (destination == null) {
      emit(state.copyWith(
        isWorking: false,
        failure: BackupFailure(
          message: '${kind.displayKorean} destination을 찾을 수 없습니다',
        ),
      ));
      return;
    }

    final available = await destination.isAvailable;
    if (!available) {
      emit(state.copyWith(
        isWorking: false,
        failure: BackupFailure(
          message: '${kind.displayKorean}은(는) 이 기기에서 사용할 수 없습니다',
        ),
      ));
      return;
    }

    final exportResult = await _localProvider.exportDriftDatabase();
    final exportLeft = exportResult.swap().toNullable();
    if (exportLeft != null) {
      emit(state.copyWith(
        isWorking: false,
        failure: BackupFailure(message: exportLeft.message),
      ));
      return;
    }
    final file = exportResult.getRight().toNullable();
    if (file == null) {
      emit(state.copyWith(
        isWorking: false,
        failure: const BackupFailure(message: '백업 파일을 생성하지 못했습니다'),
      ));
      return;
    }

    final suggestedName = p.basename(file.path);
    final sendResult = await destination.sendFile(file.path, suggestedName);

    sendResult.fold(
      (failure) => emit(state.copyWith(
        isWorking: false,
        failure: failure,
      )),
      (_) => emit(state.copyWith(
        isWorking: false,
        successMessage: '${kind.displayKorean}(으)로 백업을 보냈습니다',
        lastSuccessKind: kind,
      )),
    );
  }
}
