import 'dart:collection';

import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:equatable/equatable.dart';
import '../../../common/moment/domain/entity/moment.dart';

class MomentListState extends Equatable {
  final LinkedHashMap<DateTime, List<Moment>> moments;
  final DateTime? firstDay;
  final LocalFailure? failure;

  const MomentListState({
    required this.moments,
    this.firstDay,
    this.failure,
  });

  @override
  List<Object?> get props => [moments, firstDay];

  MomentListState copyWith({
    LinkedHashMap<DateTime, List<Moment>>? moments,
    DateTime? firstDay,
    LocalFailure? failure,
  }) {
    return MomentListState(
      moments: moments ?? this.moments,
      firstDay: firstDay ?? this.firstDay,
      failure: failure ?? this.failure,
    );
  }
}
