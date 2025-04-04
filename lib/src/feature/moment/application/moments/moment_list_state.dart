import 'dart:collection';

import 'package:equatable/equatable.dart';
import '../../domain/entity/moment.dart';

class MomentListState extends Equatable {
  final LinkedHashMap<DateTime, List<Moment>> moments;
  final DateTime? firstDay;

  const MomentListState({
    required this.moments,
    this.firstDay,
  });

  @override
  List<Object?> get props => [moments, firstDay];

  MomentListState copyWith({
    LinkedHashMap<DateTime, List<Moment>>? moments,
    DateTime? firstDay,
  }) {
    return MomentListState(
      moments: moments ?? this.moments,
      firstDay: firstDay ?? this.firstDay,
    );
  }
}
