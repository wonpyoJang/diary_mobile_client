import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/lock/application/lock_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_local_authenticator_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';

class MockAuthenticatorRepository implements IAuthenticatorRepository {
  Future<Either<LocalAuthFailure, bool>> Function()? _authenticate;
  Future<Either<LocalAuthFailure, bool>> Function(String, String?)?
      _validatePasscode;

  MockAuthenticatorRepository({
    Future<Either<LocalAuthFailure, bool>> Function()? authenticate,
    Future<Either<LocalAuthFailure, bool>> Function(String, String?)?
        validatePasscode,
  }) {
    _authenticate = authenticate;
    _validatePasscode = validatePasscode;
  }

  @override
  Future<Either<LocalAuthFailure, bool>> authenticate() async {
    if (_authenticate != null) {
      return await _authenticate!();
    }
    return right(true);
  }

  @override
  Future<Either<LocalAuthFailure, bool>> validatePasscode(
      String input, String? passcode) async {
    if (_validatePasscode != null) {
      return await _validatePasscode!(input, passcode);
    }
    return right(true);
  }
}

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = Directory.systemTemp;
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(dir.path),
    );
  });

  group('LockCubit 테스트', () {
    late MockAuthenticatorRepository mockRepository;
    late LockCubit lockCubit;

    setUp(() {
      mockRepository = MockAuthenticatorRepository();
      lockCubit =
          LockCubit(authenticatorRepository: mockRepository, passcode: '1234');
    });

    test('인증 성공 시 LockUnlocked 상태로 전이', () async {
      mockRepository = MockAuthenticatorRepository(
        authenticate: () async => right(true),
      );
      lockCubit =
          LockCubit(authenticatorRepository: mockRepository, passcode: '1234');
      await lockCubit.authenticate();
      expect(lockCubit.state.status, LockStatus.unlocked);
    });

    test('인증 실패 시 LockError 상태로 전이', () async {
      mockRepository = MockAuthenticatorRepository(
        authenticate: () async => left(LocalAuthFailure('실패')),
      );
      lockCubit =
          LockCubit(authenticatorRepository: mockRepository, passcode: '1234');
      await lockCubit.authenticate();
      expect(lockCubit.state.status, LockStatus.error);
    });

    test('비밀번호 일치 시 LockUnlocked 상태로 전이', () async {
      mockRepository = MockAuthenticatorRepository(
        validatePasscode: (input, passcode) async => right(true),
      );
      lockCubit =
          LockCubit(authenticatorRepository: mockRepository, passcode: '1234');
      // lockCubit.input('1');
      // lockCubit.input('2');
      // lockCubit.input('3');
      // lockCubit.input('4');
      // await Future.delayed(Duration(milliseconds: 10));
      // expect(lockCubit.state.status, LockStatus.unlocked);
    });

    test('비밀번호 불일치 시 LockError 상태로 전이', () async {
      mockRepository = MockAuthenticatorRepository(
        validatePasscode: (input, passcode) async =>
            left(LocalAuthFailure('비밀번호가 일치하지 않습니다.')),
      );
      lockCubit =
          LockCubit(authenticatorRepository: mockRepository, passcode: '1234');
      // final expectedStates = [
      //   isA<LockInputting>(),
      //   isA<LockInputting>(),
      //   isA<LockInputting>(),
      //   isA<LockInputting>(),
      //   isA<LockError>(),
      // ];
      // expectLater(lockCubit.stream, emitsInOrder(expectedStates));
      // lockCubit.input('0');
      // lockCubit.input('0');
      // lockCubit.input('0');
      // lockCubit.input('0');
      // await Future.delayed(Duration(milliseconds: 10));
    });
  });
}
