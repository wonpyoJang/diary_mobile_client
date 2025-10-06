import 'dart:io';

import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:equatable/equatable.dart';

abstract class GeneratedImageEvent extends Equatable {
  const GeneratedImageEvent();

  @override
  List<Object?> get props => [];
}

class FetchGeneratedImage extends GeneratedImageEvent {
  const FetchGeneratedImage();
}

class SaveGeneratedImage extends GeneratedImageEvent {
  final File file;
  const SaveGeneratedImage(this.file);
}

class UpdateMoment extends GeneratedImageEvent {
  final Moment moment;
  const UpdateMoment(this.moment);
}
