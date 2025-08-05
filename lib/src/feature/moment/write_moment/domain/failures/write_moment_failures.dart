import 'package:equatable/equatable.dart';

abstract class WriteMomentFailure extends Equatable {
  const WriteMomentFailure({required String message});

  @override
  List<Object?> get props => [];
}

class MomentAnalyzeFailed extends WriteMomentFailure {
  final String message;

  const MomentAnalyzeFailed({required this.message}) : super(message: message);

  @override
  List<Object?> get props => [message];
}

class SelectMediasFailed extends WriteMomentFailure {
  final String message;

  const SelectMediasFailed({required this.message}) : super(message: message);

  @override
  List<Object?> get props => [message];
}

class MomentDescribeImageFailed extends WriteMomentFailure {
  final String message;

  const MomentDescribeImageFailed({required this.message})
      : super(message: message);

  @override
  List<Object?> get props => [message];
}
