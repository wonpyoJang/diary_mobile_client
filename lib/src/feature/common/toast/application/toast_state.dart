import 'package:diary_mobile_client/src/feature/common/toast/application/toast_message.dart';
import 'package:equatable/equatable.dart';

class ToastState extends Equatable {
  final List<ToastMessage> toastQueue;
  final bool isShowing;
  final ToastMessage? currentToast;

  const ToastState({
    this.toastQueue = const [],
    this.isShowing = false,
    this.currentToast,
  });

  static ToastState initial() {
    return const ToastState(
      toastQueue: [],
      isShowing: false,
      currentToast: null,
    );
  }

  @override
  List<Object?> get props => [toastQueue, isShowing, currentToast];

  ToastState copyWith({
    List<ToastMessage>? toastQueue,
    bool? isShowing,
    ToastMessage? currentToast,
  }) {
    return ToastState(
      toastQueue: toastQueue ?? this.toastQueue,
      isShowing: isShowing ?? this.isShowing,
      currentToast: currentToast ?? this.currentToast,
    );
  }
}
