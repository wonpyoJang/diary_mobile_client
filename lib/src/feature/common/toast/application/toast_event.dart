import 'package:diary_mobile_client/src/feature/common/toast/application/toast_bloc.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_message.dart';
import 'package:equatable/equatable.dart';

abstract class ToastEvent extends Equatable {
  const ToastEvent();
  @override
  List<Object?> get props => [];
}

class ShowToast extends ToastEvent {
  final String message;
  final ToastType type;
  final Duration duration;

  const ShowToast(this.message, this.type, this.duration);
  @override
  List<Object?> get props => [message, type, duration];
}

class EnqueueToast extends ToastEvent {
  final ToastMessage toast;

  const EnqueueToast(this.toast);
  @override
  List<Object?> get props => [toast];
}

class ProcessQueue extends ToastEvent {
  const ProcessQueue();
}
