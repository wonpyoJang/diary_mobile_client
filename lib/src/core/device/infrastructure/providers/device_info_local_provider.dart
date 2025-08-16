import 'package:device_info_plus/device_info_plus.dart';
import 'package:diary_mobile_client/src/core/device/infrastructure/interfaces/i_device_info_local_provider.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

@LazySingleton(as: IDeviceInfoLocalProvider)
class DeviceInfoLocalProvider implements IDeviceInfoLocalProvider {
  @override
  Future<Either<LocalFailure, String>> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    late String deviceId;

    try {
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      if (deviceInfo is AndroidDeviceInfo) {
        deviceId = deviceInfo.id;
      } else if (deviceInfo is IosDeviceInfo) {
        deviceId = deviceInfo.identifierForVendor ?? "Unknown iOS ID";
      } else if (deviceInfo is WebBrowserInfo) {
        deviceId = deviceInfo.userAgent ?? "Unknown Web ID";
      } else if (deviceInfo is LinuxDeviceInfo) {
        deviceId = deviceInfo.machineId ?? "Unknown Linux ID";
      } else if (deviceInfo is MacOsDeviceInfo) {
        deviceId = deviceInfo.systemGUID ?? "Unknown MacOS ID";
      } else if (deviceInfo is WindowsDeviceInfo) {
        deviceId = deviceInfo.deviceId;
      } else {
        deviceId = "Unknown Device ID";
      }
    } on Exception catch (e, stack) {
      debugPrint('Exception 발생: '
          '\u001b[31m$e\n$stack\u001b[0m');
      return left(const LocalFailure(
          message: "DeviceInfo 를 가져오는데 실패했습니다. (Exception)"));
    } on Error catch (e, stack) {
      debugPrint('Error 발생: '
          '\u001b[31m$e\n$stack\u001b[0m');
      return left(
          const LocalFailure(message: "DeviceInfo 를 가져오는데 실패했습니다. (Error)"));
    } catch (e, stack) {
      debugPrint('알 수 없는 예외 발생: '
          '\u001b[31m$e\n$stack\u001b[0m');
      return left(
          const LocalFailure(message: "DeviceInfo 를 가져오는데 실패했습니다. (Unknown)"));
    }

    return right(deviceId);
  }
}
