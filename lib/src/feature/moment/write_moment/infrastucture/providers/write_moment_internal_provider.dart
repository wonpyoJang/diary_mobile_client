import 'package:diary_mobile_client/src/core/http_client/http_client.dart';
import 'package:diary_mobile_client/src/core/http_client/http_failure.dart';
import 'package:diary_mobile_client/src/feature/moment/write_moment/infrastucture/interfaces/i_write_moment_internal_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IWriteMomentInternalProvider)
class WriteMomentInternalProvider implements IWriteMomentInternalProvider {
  final HttpClient client;

  WriteMomentInternalProvider(this.client);

  @override
  Future<Either<HttpFailure, Unit>> log(String log) async {
    final result = await client.request(path: "log", method: HttpMethod.post);
    return result.fold(
      (failure) => left(failure),
      (response) => right(unit),
    );
  }
}
