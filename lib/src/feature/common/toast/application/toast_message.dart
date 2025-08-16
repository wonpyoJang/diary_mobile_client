import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_cubit.dart';

class ToastMessage extends BusMessage {
  final String message;
  final ToastType type;
  final Duration duration;
  ToastMessage({
    required this.message,
    required this.type,
    required this.duration,
  });
}

class ShowToastMessage extends ToastMessage {
  ShowToastMessage({
    required super.message,
    super.type = ToastType.info,
    super.duration = const Duration(seconds: 3),
  });
}
