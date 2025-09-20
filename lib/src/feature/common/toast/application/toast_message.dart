import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_bloc.dart';

class ToastMessage {
  final String message;
  final ToastType type;
  final Duration duration;
  ToastMessage({
    required this.message,
    required this.type,
    required this.duration,
  });
}

class ShowToastMessage extends BusMessage {
  final ToastMessage toast;
  ShowToastMessage({
    required this.toast,
  });
}
