import 'package:equatable/equatable.dart';

abstract class RuntimeFeatureFlagEvent extends Equatable {
  const RuntimeFeatureFlagEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeatureFlag extends RuntimeFeatureFlagEvent {}
