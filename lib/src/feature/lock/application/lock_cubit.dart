import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_local_authenticator_repository.dart';
import 'package:equatable/equatable.dart';

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
class LockCubit extends HydratedCubit<LockState> {
  final IAuthenticatorRepository authenticatorRepository;

  LockCubit({required this.authenticatorRepository, String? passcode})
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
    final result = await authenticatorRepository.authenticate();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LockStatus.error, failure: failure)),
      (didSetLockEnabled) {
        if (didSetLockEnabled) {
          emit(state.copyWith(isLockEnabled: true));
        } else {
          emit(state.copyWith(status: LockStatus.error));
        }
      },
    );
  }

  Future<void> setLockDisabled() async {
    final result = await authenticatorRepository.authenticate();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LockStatus.error, failure: failure)),
      (didSetLockDisabled) {
        emit(state.copyWith(isLockEnabled: false));
      },
    );
  }

  void reset() {
    emit(state.copyWith(status: LockStatus.initial));
  }

  void unlock() {
    emit(state.copyWith(status: LockStatus.unlocked));
  }

  @override
  Map<String, dynamic>? toJson(LockState state) {
    return {
      'isLockEnabled': state.isLockEnabled,
    };
  }

  @override
  LockState? fromJson(Map<String, dynamic> json) {
    return LockState(
      isLockEnabled: json['isLockEnabled'] as bool,
    );
  }
}
