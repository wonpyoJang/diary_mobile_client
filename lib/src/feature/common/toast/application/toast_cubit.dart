import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import 'package:injectable/injectable.dart';

// Toast 상태 정의
abstract class ToastState extends Equatable {
  const ToastState();

  @override
  List<Object?> get props => [];
}

class ToastInitial extends ToastState {}

class ToastVisible extends ToastState {
  final String message;
  final ToastType type;
  final Duration duration;

  const ToastVisible({
    required this.message,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 3),
  });

  @override
  List<Object?> get props => [message, type, duration];
}

// Toast 타입 정의
enum ToastType {
  success,
  error,
  warning,
  info,
}

// Toast Cubit
@singleton
class ToastCubit extends Cubit<ToastState> {
  final Bus bus;
  late final StreamSubscription _busSubscription;

  final List<ShowToastMessage> _toastQueue = [];
  bool _isShowing = false;
  String? flushedMessages;

  ToastCubit(this.bus) : super(ToastInitial()) {
    _busSubscription = bus.subscribe((BusMessage message) {
      if (message is ShowToastMessage) {
        _enqueueToast(message);
      }
    });
  }

  int get queueLength => _toastQueue.length;

  void _enqueueToast(ShowToastMessage message) {
    _toastQueue.add(message);
    if (_toastQueue.length >= 5) {
      _flushQueue();
      return;
    }
    _showNextToast();
  }

  void _showNextToast() async {
    if (_isShowing || _toastQueue.isEmpty) return;
    _isShowing = true;
    final toast = _toastQueue.removeAt(0);
    showToast(
      message: toast.message,
      type: toast.type,
      duration: toast.duration,
    );
    await Future.delayed(toast.duration + const Duration(seconds: 1));
    _isShowing = false;
    if (_toastQueue.isNotEmpty) {
      _showNextToast();
    }
  }

  void _flushQueue() {
    flushedMessages = _toastQueue.map((e) => e.message).join('\n');
    _toastQueue.clear();
    emit(ToastInitial());
  }

  @override
  Future<void> close() {
    _busSubscription.cancel();
    return super.close();
  }

  void showToast({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    emit(ToastVisible(
      message: message,
      type: type,
      duration: duration,
    ));

    // 지정된 시간 후 토스트 숨기기
    Future.delayed(duration, () {
      if (state is ToastVisible) {
        hideToast();
      }
    });
  }

  void showSuccess(String message) {
    showToast(message: message, type: ToastType.success);
  }

  void showError(String message) {
    showToast(message: message, type: ToastType.error);
  }

  void showWarning(String message) {
    showToast(message: message, type: ToastType.warning);
  }

  void showInfo(String message) {
    showToast(message: message, type: ToastType.info);
  }

  void hideToast() {
    emit(ToastInitial());
  }
}
