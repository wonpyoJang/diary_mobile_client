import 'package:diary_mobile_client/src/feature/data_control/domain/failures/data_control_failure.dart';
import 'package:diary_mobile_client/src/feature/data_control/domain/repositories/interfaces/i_data_control_repository.dart';
import 'package:diary_mobile_client/src/feature/data_control/infrastructure/providers/interfaces/i_local_data_control_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IDataControlRepository)
class DataControlRepository implements IDataControlRepository {
  final ILocalDataControlProvider dataControlProvider;

  DataControlRepository({
    required this.dataControlProvider,
  });

  @override
  Future<Either<DataControlFailure, Unit>> setSendDataToServer() async {
    return await dataControlProvider.setSendDataToServer();
  }

  @override
  Future<Either<DataControlFailure, Unit>> unsetSendDataToServer() async {
    return await dataControlProvider.unsetSendDataToServer();
  }

  @override
  Future<Either<DataControlFailure, bool>> getSendDataToServer() async {
    return await dataControlProvider.getSendDataToServer();
  }
}
