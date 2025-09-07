import 'package:diary_mobile_client/src/feature/data_control/domain/failures/data_control_failure.dart';
import 'package:equatable/equatable.dart';

class DataControlState extends Equatable {
  final bool allowedSendDataToServer;
  final DataControlFailure? failure;
  const DataControlState({this.allowedSendDataToServer = false, this.failure});
  @override
  List<Object?> get props => [allowedSendDataToServer, failure];

  DataControlState copyWith(
      {bool? allowedSendDataToServer, DataControlFailure? failure}) {
    return DataControlState(
      allowedSendDataToServer:
          allowedSendDataToServer ?? this.allowedSendDataToServer,
      failure: failure ?? this.failure,
    );
  }
}
