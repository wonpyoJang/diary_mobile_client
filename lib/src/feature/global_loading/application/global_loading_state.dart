import 'package:equatable/equatable.dart';

class GlobalLoadingState extends Equatable {
  final bool isLoading;
  const GlobalLoadingState({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];

  GlobalLoadingState copyWith({bool? isLoading}) {
    return GlobalLoadingState(isLoading: isLoading ?? this.isLoading);
  }
}
