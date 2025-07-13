import 'dart:io';

import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entity/moment.dart';
import 'write_moment_bloc.dart';

class WriteMomentState extends Equatable {
  final WriteMode mode;
  final Moment moment;
  final bool isLoading;
  final bool isSaved;
  final String errorMessage;
  final WriteMomentFailure? failure;
  final List<File> medias;

  const WriteMomentState({
    required this.mode,
    required this.moment,
    this.isLoading = false,
    this.isSaved = false,
    this.errorMessage = '',
    this.failure,
    this.medias = const [],
  });

  WriteMomentState copyWith({
    Moment? moment,
    bool? isLoading,
    bool? isSaved,
    String? errorMessage,
    WriteMomentFailure? failure,
    WriteMode? mode, // mode 추가
    List<File>? medias,
  }) {
    return WriteMomentState(
      moment: moment ?? this.moment,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      mode: mode ?? this.mode, // mode 추가
      medias: medias ?? this.medias,
    );
  }

  @override
  List<Object?> get props =>
      [mode, moment, isLoading, isSaved, errorMessage, failure, medias];
}
