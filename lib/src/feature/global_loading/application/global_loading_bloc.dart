import 'dart:async';

import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/feature/global_loading/application/global_loading_event.dart';
import 'package:diary_mobile_client/src/feature/global_loading/application/global_loading_state.dart';
import 'package:diary_mobile_client/src/feature/global_loading/application/messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class GlobalLoadingBloc extends Bloc<GlobalLoadingEvent, GlobalLoadingState> {
  final Bus bus;
  late StreamSubscription<BusMessage> busSubscription;

  @override
  Future<void> close() {
    busSubscription.cancel();
    return super.close();
  }

  GlobalLoadingBloc(this.bus) : super(const GlobalLoadingState()) {
    busSubscription = bus.subscribe((message) {
      if (message is SetGlobalLoadingMessage) {
        add(const SetGlobalLoading());
      } else if (message is UnsetGlobalLoadingMessage) {
        add(const UnsetGlobalLoading());
      }
    });

    on<SetGlobalLoading>((event, emit) {
      emit(state.copyWith(isLoading: true));
    });

    on<UnsetGlobalLoading>((event, emit) {
      emit(state.copyWith(isLoading: false));
    });
  }
}
