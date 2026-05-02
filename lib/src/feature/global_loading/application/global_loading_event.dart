import 'package:equatable/equatable.dart';

abstract class GlobalLoadingEvent extends Equatable {
  const GlobalLoadingEvent();

  @override
  List<Object?> get props => [];
}

class SetGlobalLoading extends GlobalLoadingEvent {
  const SetGlobalLoading();
}

class UnsetGlobalLoading extends GlobalLoadingEvent {
  const UnsetGlobalLoading();
}
