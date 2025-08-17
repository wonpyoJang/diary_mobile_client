import 'package:diary_mobile_client/src/feature/data_control/application/data_control_event.dart';
import 'package:diary_mobile_client/src/feature/data_control/application/data_control_state.dart';
import 'package:diary_mobile_client/src/feature/data_control/domain/failures/data_control_failure.dart';
import 'package:diary_mobile_client/src/feature/data_control/domain/repositories/interfaces/i_data_control_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_local_authenticator_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';

@lazySingleton
class DataControlBloc extends Bloc<DataControlEvent, DataControlState> {
  final IDataControlRepository dataControlRepository;
  final IAuthenticatorRepository authenticatorRepository;

  DataControlBloc(
      {required this.dataControlRepository,
      required this.authenticatorRepository})
      : super(const DataControlState()) {
    on<SetSendDataToServer>((event, emit) async {
      final result = await TaskEither<LocalAuthFailure, bool>(
        () async => await authenticatorRepository.authenticate(),
      )
          .mapLeft((l) => DataControlFailure(l.message))
          .filterOrElse((did) => did, (_) => DataControlFailure('인증 실패'))
          .flatMap((_) => TaskEither<DataControlFailure, Unit>(
              () async => await dataControlRepository.setSendDataToServer()))
          .run();

      emit(result.fold(
        (failure) => state.copyWith(failure: failure),
        (_) => state.copyWith(allowedSendDataToServer: true),
      ));
    });

    on<UnsetSendDataToServer>((event, emit) async {
      final result = await TaskEither<LocalAuthFailure, bool>(
        () async => await authenticatorRepository.authenticate(),
      )
          .mapLeft((l) => DataControlFailure(l.message))
          .filterOrElse((did) => did, (_) => DataControlFailure('인증 실패'))
          .flatMap((_) => TaskEither<DataControlFailure, Unit>(
              () async => await dataControlRepository.unsetSendDataToServer()))
          .run();

      emit(result.fold(
        (failure) => state.copyWith(failure: failure),
        (_) => state.copyWith(allowedSendDataToServer: false),
      ));
    });
  }
}
