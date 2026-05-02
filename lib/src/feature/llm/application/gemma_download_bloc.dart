import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../infrastructure/services/gemma_model_download_manager.dart';

part 'gemma_download_event.dart';
part 'gemma_download_state.dart';

@injectable
class GemmaDownloadBloc extends Bloc<GemmaDownloadEvent, GemmaDownloadState> {
  GemmaDownloadBloc(this._downloadManager) : super(const GemmaDownloadIdle()) {
    on<GemmaDownloadStart>(_onStart);
    on<GemmaDownloadCancel>(_onCancel);
    on<GemmaDownloadProgressUpdated>(_onProgressUpdated);
  }

  final GemmaModelDownloadManager _downloadManager;
  CancelToken? _cancelToken;

  Future<void> _onStart(
    GemmaDownloadStart event,
    Emitter<GemmaDownloadState> emit,
  ) async {
    emit(const GemmaDownloadCheckingSpace());

    final hasSpace = await _downloadManager.hasEnoughStorage();
    if (!hasSpace) {
      emit(GemmaDownloadInsufficientSpace(
        requiredBytes: _downloadManager.requiredSpaceBytes,
      ));
      return;
    }

    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    emit(const GemmaDownloadDownloading(progress: 0.0));

    try {
      await _downloadManager.download(
        cancelToken: cancelToken,
        onProgress: (progress) {
          // Forward progress through the event stream so we don't emit
          // from a non-handler callback.
          if (!isClosed) {
            add(GemmaDownloadProgressUpdated(progress));
          }
        },
      );
      if (cancelToken.isCancelled) {
        emit(const GemmaDownloadCancelled());
        return;
      }
      emit(const GemmaDownloadSuccess());
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        emit(const GemmaDownloadCancelled());
      } else {
        emit(GemmaDownloadFailure(message: e.message ?? '네트워크 오류'));
      }
    } catch (e) {
      emit(GemmaDownloadFailure(message: e.toString()));
    } finally {
      _cancelToken = null;
    }
  }

  void _onCancel(
    GemmaDownloadCancel event,
    Emitter<GemmaDownloadState> emit,
  ) {
    final token = _cancelToken;
    if (token != null && !token.isCancelled) {
      token.cancel('user_cancelled');
    }
  }

  void _onProgressUpdated(
    GemmaDownloadProgressUpdated event,
    Emitter<GemmaDownloadState> emit,
  ) {
    final current = state;
    if (current is GemmaDownloadDownloading) {
      emit(GemmaDownloadDownloading(progress: event.progress));
    }
  }

  @override
  Future<void> close() {
    final token = _cancelToken;
    if (token != null && !token.isCancelled) {
      token.cancel('bloc_closed');
    }
    return super.close();
  }
}
