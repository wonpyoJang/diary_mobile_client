import 'dart:io';

import 'package:diary_mobile_client/src/feature/common/moment/domain/entity/moment.dart';
import 'package:equatable/equatable.dart';

class GeneratedImageState extends Equatable {
  final File? generatedImage;
  final String? errorMessage;
  final Moment? moment;

  const GeneratedImageState(
      {this.generatedImage, this.errorMessage, this.moment});

  factory GeneratedImageState.initial() {
    return const GeneratedImageState();
  }

  @override
  List<Object?> get props => [generatedImage, errorMessage, moment];

  GeneratedImageState copyWith(
      {File? generatedImage, String? errorMessage, Moment? moment}) {
    return GeneratedImageState(
      generatedImage: generatedImage ?? this.generatedImage,
      errorMessage: errorMessage ?? this.errorMessage,
      moment: moment ?? this.moment,
    );
  }
}
