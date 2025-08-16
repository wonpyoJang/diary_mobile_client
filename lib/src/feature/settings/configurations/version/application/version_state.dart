part of 'version_bloc.dart';

abstract class VersionState extends Equatable {
  const VersionState();

  @override
  List<Object?> get props => [];
}

class VersionInitial extends VersionState {
  const VersionInitial();
}

class VersionLoading extends VersionState {
  const VersionLoading();
}

class VersionLoaded extends VersionState {
  final String version;
  final String buildNumber;

  const VersionLoaded({required this.version, required this.buildNumber});

  @override
  List<Object?> get props => [version, buildNumber];
}

class VersionError extends VersionState {
  final String message;

  const VersionError({required this.message});

  @override
  List<Object?> get props => [message];
}
