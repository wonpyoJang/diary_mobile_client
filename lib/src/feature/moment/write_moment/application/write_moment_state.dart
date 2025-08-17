import 'package:diary_mobile_client/src/feature/moment/write_moment/domain/failures/write_moment_failures.dart';
import 'package:equatable/equatable.dart';

import '../../../common/moment/domain/entity/moment.dart';
import 'write_moment_bloc.dart';

class WriteMomentState extends Equatable {
  final WriteMode mode;
  final Moment moment;
  final bool isLoading;
  final bool isSaved;
  final bool hasAnalyzed;
  final String errorMessage;
  final WriteMomentFailure? failure;
  final bool isTextGenerated;

  const WriteMomentState({
    required this.mode,
    required this.moment,
    this.isLoading = false,
    this.isSaved = false,
    this.hasAnalyzed = false,
    this.errorMessage = '',
    this.failure,
    this.isTextGenerated = false,
  });

  WriteMomentState copyWith({
    Moment? moment,
    bool? isLoading,
    bool? isSaved,
    bool? hasAnalyzed,
    String? errorMessage,
    WriteMomentFailure? failure,
    WriteMode? mode, // mode 추가
    bool? isTextGenerated,
  }) {
    return WriteMomentState(
      moment: moment ?? this.moment,
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
      hasAnalyzed: hasAnalyzed ?? this.hasAnalyzed,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
      mode: mode ?? this.mode, // mode 추가
      isTextGenerated: isTextGenerated ?? this.isTextGenerated,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        moment,
        isLoading,
        isSaved,
        hasAnalyzed,
        errorMessage,
        failure,
        isTextGenerated
      ];
}
