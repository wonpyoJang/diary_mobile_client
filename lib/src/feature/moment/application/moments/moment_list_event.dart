import 'package:equatable/equatable.dart';

import '../../domain/entity/moment.dart';

abstract class MomentListEvent extends Equatable {
  const MomentListEvent();

  @override
  List<Object?> get props => [];
}

class LoadMoments extends MomentListEvent {}

class AddMoment extends MomentListEvent {
  final Moment moment;
  final DateTime date;

  const AddMoment(this.moment, this.date);

  @override
  List<Object?> get props => [moment, date];
}

class UpdateMoment extends MomentListEvent {
  final Moment moment;
  final DateTime date;

  const UpdateMoment(this.moment, this.date);

  @override
  List<Object?> get props => [moment, date];
}

class DeleteMoment extends MomentListEvent {
  final Moment moment;

  const DeleteMoment(this.moment);

  @override
  List<Object?> get props => [moment];
}
