import 'package:diary_mobile_client/src/feature/data_control/domain/failures/data_control_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'interfaces/i_local_data_control_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client.dart';
import 'package:diary_mobile_client/src/core/hive_client/hive_client_extensions.dart';

@Injectable(as: ILocalDataControlProvider)
class LocalDataControlProvider implements ILocalDataControlProvider {
  final HiveClient hiveClient;

  LocalDataControlProvider(this.hiveClient);

  static const String _kSendDataKey = 'allowed_send_data_to_server';

  @override
  Future<Either<DataControlFailure, Unit>> setSendDataToServer() async {
    final result = await hiveClient.saveUserSetting<bool>(_kSendDataKey, true);
    return result.fold(
      (failure) => left(DataControlFailure(failure.message)),
      (_) => right(unit),
    );
  }

  @override
  Future<Either<DataControlFailure, Unit>> unsetSendDataToServer() async {
    final result = await hiveClient.saveUserSetting<bool>(_kSendDataKey, false);
    return result.fold(
      (failure) => left(DataControlFailure(failure.message)),
      (_) => right(unit),
    );
  }
}
