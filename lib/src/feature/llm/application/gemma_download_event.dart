part of 'gemma_download_bloc.dart';

abstract class GemmaDownloadEvent extends Equatable {
  const GemmaDownloadEvent();

  @override
  List<Object?> get props => [];
}

class GemmaDownloadStart extends GemmaDownloadEvent {
  const GemmaDownloadStart();
}

class GemmaDownloadCancel extends GemmaDownloadEvent {
  const GemmaDownloadCancel();
}

/// Internal event emitted from the dio download progress callback.
class GemmaDownloadProgressUpdated extends GemmaDownloadEvent {
  final double progress;

  const GemmaDownloadProgressUpdated(this.progress);

  @override
  List<Object?> get props => [progress];
}
