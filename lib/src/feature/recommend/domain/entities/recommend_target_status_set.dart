import 'package:equatable/equatable.dart';

class RecommendTargetStatusSet extends Equatable {
  final bool isSendingDataToServer;
  final bool isLocked;

  const RecommendTargetStatusSet(
      {required this.isSendingDataToServer, required this.isLocked});

  @override
  List<Object?> get props => [isSendingDataToServer, isLocked];
}
