import 'package:diary_mobile_client/src/feature/data_control/domain/failures/data_control_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class ILocalDataControlProvider {
  Future<Either<DataControlFailure, Unit>> setSendDataToServer();
  Future<Either<DataControlFailure, Unit>> unsetSendDataToServer();
}
