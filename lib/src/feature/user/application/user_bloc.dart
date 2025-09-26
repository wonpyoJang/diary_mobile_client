import 'dart:async';

import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/bus/bus_message.dart';
import 'package:diary_mobile_client/src/feature/common/toast/presentatioin/show_toast.dart';
import 'package:diary_mobile_client/src/feature/signin/application/messages.dart';
import 'package:diary_mobile_client/src/feature/user/application/user_event.dart';
import 'package:diary_mobile_client/src/feature/user/application/user_state.dart';
import 'package:diary_mobile_client/src/feature/user/domain/interfaces/i_user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository repository;
  final Bus bus;
  late StreamSubscription<BusMessage> busSubscription;

  UserBloc(this.repository, this.bus) : super(UserState.initial()) {
    busSubscription = bus.subscribe((message) {
      if (message is SignInSuccessMessage) {
        add(FetchUser());
      }
    });

    on<FetchUser>((event, emit) async {
      final result = await repository.getAndStoreUser();
      emit(result.fold(
        (failure) {
          return state.copyWith(failure: failure);
        },
        (user) {
          return state.copyWith(user: user);
        },
      ));
    });

    on<LoadSavedUser>((event, emit) async {
      final result = await repository.getAndStoreUser();
      emit(result.fold(
        (failure) {
          return state.copyWith(failure: failure);
        },
        (user) {
          return state.copyWith(user: user);
        },
      ));
    });

    on<SignOut>((event, emit) async {
      final result = await repository.signOut();
      emit(result.fold(
        (failure) {
          return state.copyWith(failure: failure);
        },
        (_) {
          showToast('로그아웃 성공');
          return const UserState(user: null, failure: null);
        },
      ));
    });
  }
}
