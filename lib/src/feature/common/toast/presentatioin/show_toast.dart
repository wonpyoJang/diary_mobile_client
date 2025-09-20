import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_bloc.dart';
import 'package:diary_mobile_client/src/feature/common/toast/application/toast_message.dart';
import 'package:diary_mobile_client/src/injection.dart';

showToast(String message,
    {ToastType? type = ToastType.info,
    Duration duration = const Duration(seconds: 3)}) {
  getIt<Bus>().publish(ShowToastMessage(
    toast: ToastMessage(
      message: message,
      type: type ?? ToastType.info,
      duration: duration,
    ),
  ));
}
