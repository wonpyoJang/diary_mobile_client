import 'package:diary_mobile_client/src/bus/bus.dart';
import 'package:diary_mobile_client/src/feature/signin/application/messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../domain/interfaces/i_auth_repository.dart';
import 'signin_event.dart';
import 'signin_state.dart';

@injectable
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final IAuthRepository repository;
  final Bus bus;
  SignInBloc(this.repository, this.bus) : super(AuthInitial()) {
    on<SignInWithKakao>((event, emit) async {
      emit(AuthLoading());
      final result = await repository.signInWithKakao();
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (result) {
          if (result) {
            emit(const Authenticated(
                userId: 'kakao_user', email: 'kakao@kakao.com'));
          } else {
            emit(const AuthError('Failed to sign in with Kakao'));
          }
        },
      );
    });
    on<SignInWithApple>((event, emit) async {
      emit(AuthLoading());
      final result = await repository.signInWithApple();
      emit(result.fold(
        (failure) => AuthError(failure.message),
        (_) {
          bus.publish(SignInSuccessMessage());
          return const Authenticated(
              userId: 'apple_user', email: 'apple@apple.com');
        },
      ));
    });
    on<SignOut>((event, emit) async {
      emit(AuthLoading());
      final result = await repository.signOut();
      emit(result.fold(
        (failure) => AuthError(failure.message),
        (_) {
          return Unauthenticated();
        },
      ));
    });
  }
}
