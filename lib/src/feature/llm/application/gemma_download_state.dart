part of 'gemma_download_bloc.dart';

abstract class GemmaDownloadState extends Equatable {
  const GemmaDownloadState();

  @override
  List<Object?> get props => [];
}

class GemmaDownloadIdle extends GemmaDownloadState {
  const GemmaDownloadIdle();
}

class GemmaDownloadCheckingSpace extends GemmaDownloadState {
  const GemmaDownloadCheckingSpace();
}

class GemmaDownloadInsufficientSpace extends GemmaDownloadState {
  final int requiredBytes;

  const GemmaDownloadInsufficientSpace({required this.requiredBytes});

  @override
  List<Object?> get props => [requiredBytes];
}

class GemmaDownloadDownloading extends GemmaDownloadState {
  final double progress;

  const GemmaDownloadDownloading({required this.progress});

  @override
  List<Object?> get props => [progress];
}

class GemmaDownloadSuccess extends GemmaDownloadState {
  const GemmaDownloadSuccess();
}

class GemmaDownloadFailure extends GemmaDownloadState {
  final String message;

  const GemmaDownloadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class GemmaDownloadCancelled extends GemmaDownloadState {
  const GemmaDownloadCancelled();
}
