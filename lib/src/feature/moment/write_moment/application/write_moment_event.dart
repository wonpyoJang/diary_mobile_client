import 'package:equatable/equatable.dart';

abstract class WriteMomentEvent extends Equatable {
  const WriteMomentEvent();

  @override
  List<Object?> get props => [];
}

class TextChangedEvent extends WriteMomentEvent {
  final String newText;

  const TextChangedEvent(this.newText);

  @override
  List<Object?> get props => [newText];
}

class Analyzed extends WriteMomentEvent {
  const Analyzed();

  @override
  List<Object?> get props => [];
}

class ChangeToEdit extends WriteMomentEvent {
  const ChangeToEdit();

  @override
  List<Object?> get props => [];
}

class AddMedias extends WriteMomentEvent {
  const AddMedias();

  @override
  List<Object?> get props => [];
}
