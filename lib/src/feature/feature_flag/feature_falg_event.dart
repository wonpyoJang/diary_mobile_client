import 'package:equatable/equatable.dart';

abstract class FeatureFlagEvent extends Equatable {
  const FeatureFlagEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeatureFlag extends FeatureFlagEvent {}
