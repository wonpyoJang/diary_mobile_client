import 'package:diary_mobile_client/src/feature/common/toast/presentatioin/show_toast.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_local_authenticator_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_lock_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

enum LockStatus {
  initial,
  locked,
  unlocked,
  error,
  inputting,
}

// 잠금 상태 정의
class LockState extends Equatable {
  final bool isLockEnabled;
  final LockStatus status;
  final LocalAuthFailure? failure;
  const LockState(
      {this.isLockEnabled = false,
      this.status = LockStatus.initial,
      this.failure});

  LockState copyWith(
      {bool? isLockEnabled, LockStatus? status, LocalAuthFailure? failure}) {
    return LockState(
        isLockEnabled: isLockEnabled ?? this.isLockEnabled,
        status: status ?? this.status,
        failure: failure ?? this.failure);
  }

  @override
  List<Object?> get props => [isLockEnabled, status, failure];
}

// 인증 관련 인터페이스 정의 (domain/interfaces)

@singleton
class LockCubit extends Cubit<LockState> {
  final IAuthenticatorRepository authenticatorRepository;
  final ILockRepository lockRepository;

  LockCubit(
      {required this.authenticatorRepository,
      required this.lockRepository,
      String? passcode})
      : super(const LockState());

  Future<void> authenticate() async {
    final result = await authenticatorRepository.authenticate();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LockStatus.error, failure: failure)),
      (didAuthenticate) {
        if (didAuthenticate) {
          emit(state.copyWith(status: LockStatus.unlocked));
        } else {
          emit(state.copyWith(status: LockStatus.error));
        }
      },
    );
  }

  Future<void> setLockEnabled(bool isLockEnabled) async {
    await _withAuthenticated(
      action: () => lockRepository.setLockEnabled(),
      onSuccess: (enabled) {
        showToast('앱 잠금을 활성화하였습니다.');
        emit(state.copyWith(isLockEnabled: enabled));
      },
    );
  }

  Future<void> setLockDisabled() async {
    await _withAuthenticated(
      action: () => lockRepository.setLockDisabled(),
      onSuccess: (disabled) {
        showToast('앱 잠금을 비활성화하였습니다.');
        emit(state.copyWith(isLockEnabled: disabled));
      },
    );
  }

  Future<void> loadLockEnabled() async {
    final result = await lockRepository.getLockEnabled();
    result.fold(
      (_) => emit(state.copyWith(isLockEnabled: false)),
      (isEnabled) {
        emit(state.copyWith(isLockEnabled: isEnabled));
      },
    );
  }

  void reset() {
    emit(state.copyWith(status: LockStatus.initial));
  }

  void unlock() {
    emit(state.copyWith(status: LockStatus.unlocked));
  }

  Future<void> _withAuthenticated({
    required Future<Either<dynamic, bool>> Function() action,
    required void Function(bool) onSuccess,
  }) async {
    final authEither = await authenticatorRepository.authenticate();
    await authEither
        .flatMap((didAuthenticate) => didAuthenticate
            ? right(unit)
            : left(LocalAuthFailure('Authentication failed')))
        .fold(
      (failure) async =>
          emit(state.copyWith(status: LockStatus.error, failure: failure)),
      (_) async {
        final repoResult = await action();
        repoResult.fold(
          (_) => emit(state.copyWith(status: LockStatus.error)),
          (value) => onSuccess(value),
        );
      },
    );
  }
}
