import 'package:equatable/equatable.dart';

abstract class DataControlEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetSendDataToServer extends DataControlEvent {
  SetSendDataToServer();
  @override
  List<Object?> get props => [];
}

class UnsetSendDataToServer extends DataControlEvent {
  UnsetSendDataToServer();
  @override
  List<Object?> get props => [];
}
