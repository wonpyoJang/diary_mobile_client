import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../domain/repositories/interfaces/i_version_repository.dart';

part 'version_state.dart';

@injectable
class VersionBloc extends Cubit<VersionState> {
  final IVersionRepository repository;
  VersionBloc(this.repository) : super(const VersionInitial());

  Future<void> fetchVersionInfo() async {
    emit(const VersionLoading());
    final versionOrFailure = await repository.getVersion();
    final buildNumberOrFailure = await repository.getBuildNumber();
    versionOrFailure.fold(
      (failure) => emit(VersionError(message: failure.message)),
      (version) {
        buildNumberOrFailure.fold(
          (failure) => emit(VersionError(message: failure.message)),
          (buildNumber) =>
              emit(VersionLoaded(version: version, buildNumber: buildNumber)),
        );
      },
    );
  }
}
