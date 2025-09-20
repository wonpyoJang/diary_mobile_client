import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_event.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_message.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:injectable/injectable.dart';

// Toast 타입 정의
enum ToastType {
  success,
  error,
  warning,
  info,
}

// Toast Cubit
@lazySingleton
class ToastBloc extends Bloc<ToastEvent, ToastState> {
  final Bus bus;
  late final StreamSubscription _busSubscription;
  bool _isProcessing = false;

  ToastBloc(this.bus) : super(ToastState.initial()) {
    _busSubscription = bus.subscribe((BusMessage message) {
      if (message is ShowToastMessage) {
        _enqueueToast(message.toast);
      }
    });

    on<EnqueueToast>((event, emit) {
      emit(state.copyWith(toastQueue: [...state.toastQueue, event.toast]));
      if (!_isProcessing) {
        add(const ProcessQueue());
      }
    });

    on<ProcessQueue>((event, emit) async {
      await _processQueue(emit);
    });

    // 기존 ShowToast 이벤트는 사용하지 않습니다. (Bus를 통해 큐에 적재)
  }

  void _enqueueToast(ToastMessage toast) {
    add(EnqueueToast(toast));
  }

  Future<void> _processQueue(Emitter<ToastState> emit) async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      while (state.toastQueue.isNotEmpty) {
        final ToastMessage current = state.toastQueue.first;

        // 표시 시작: currentToast를 현재 아이템으로 설정
        emit(state.copyWith(isShowing: true, currentToast: current));

        // 지정된 시간만큼 표시 유지
        await Future.delayed(current.duration);

        // 표시 종료 및 큐에서 제거
        final List<ToastMessage> updatedQueue = List.of(state.toastQueue);
        if (updatedQueue.isNotEmpty) {
          updatedQueue.removeAt(0);
        }
        // 표시 종료: 큐 업데이트 및 currentToast 해제
        emit(ToastState(
          toastQueue: updatedQueue,
          isShowing: false,
          currentToast: null,
        ));
      }
    } finally {
      _isProcessing = false;
    }
  }

  int get queueLength => state.toastQueue.length;

  @override
  Future<void> close() {
    _busSubscription.cancel();
    return super.close();
  }
}
