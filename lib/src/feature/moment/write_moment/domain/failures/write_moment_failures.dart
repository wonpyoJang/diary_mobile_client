import 'package:equatable/equatable.dart';

abstract class WriteMomentFailure extends Equatable {
  final String message;
  const WriteMomentFailure({required this.message});

  @override
  List<Object?> get props => [];
}

class MomentAnalyzeFailed extends WriteMomentFailure {
  const MomentAnalyzeFailed({required super.message});

  @override
  List<Object?> get props => [message];
}

class SelectMediasFailed extends WriteMomentFailure {
  const SelectMediasFailed({required super.message});

  @override
  List<Object?> get props => [message];
}

class MomentDescribeImageFailed extends WriteMomentFailure {
  const MomentDescribeImageFailed({required super.message});

  @override
  List<Object?> get props => [message];
}

class SaveMomentFailed extends WriteMomentFailure {
  const SaveMomentFailed({required super.message});

  @override
  List<Object?> get props => [message];
}

class SaveMediaFailed extends WriteMomentFailure {
  const SaveMediaFailed({required super.message});

  @override
  List<Object?> get props => [message];
}

class FetchMediaByMomentIdFailed extends WriteMomentFailure {
  const FetchMediaByMomentIdFailed({required super.message});

  @override
  List<Object?> get props => [message];
}
