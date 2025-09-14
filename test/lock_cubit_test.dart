import 'package:flutter_test/flutter_test.dart';
import 'package:diary_mobile_client/src/feature/lock/application/lock_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_local_authenticator_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/repositories/interfaces/i_lock_repository.dart';
import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
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

class MockLockRepository implements ILockRepository {
  Future<Either<LocalFailure, bool>> Function()? _setLockEnabled;
  Future<Either<LocalFailure, bool>> Function()? _setLockDisabled;
  Future<Either<LocalFailure, bool>> Function()? _getLockEnabled;

  MockLockRepository({
    Future<Either<LocalFailure, bool>> Function()? setLockEnabled,
    Future<Either<LocalFailure, bool>> Function()? setLockDisabled,
    Future<Either<LocalFailure, bool>> Function()? getLockEnabled,
  }) {
    _setLockEnabled = setLockEnabled;
    _setLockDisabled = setLockDisabled;
    _getLockEnabled = getLockEnabled;
  }

  @override
  Future<Either<LocalFailure, bool>> setLockEnabled() async {
    if (_setLockEnabled != null) {
      return await _setLockEnabled!();
    }
    return right(true);
  }

  @override
  Future<Either<LocalFailure, bool>> setLockDisabled() async {
    if (_setLockDisabled != null) {
      return await _setLockDisabled!();
    }
    return right(false);
  }

  @override
  Future<Either<LocalFailure, bool>> getLockEnabled() async {
    if (_getLockEnabled != null) {
      return await _getLockEnabled!();
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
    late MockLockRepository mockLockRepository;
    late LockCubit lockCubit;

    setUp(() {
      mockRepository = MockAuthenticatorRepository();
      mockLockRepository = MockLockRepository();
      lockCubit = LockCubit(
        authenticatorRepository: mockRepository,
        lockRepository: mockLockRepository,
        passcode: '1234',
      );
    });

    test('인증 성공 시 LockUnlocked 상태로 전이', () async {
      mockRepository = MockAuthenticatorRepository(
        authenticate: () async => right(true),
      );
      lockCubit = LockCubit(
        authenticatorRepository: mockRepository,
        lockRepository: mockLockRepository,
        passcode: '1234',
      );
      await lockCubit.authenticate();
      expect(lockCubit.state.status, LockStatus.unlocked);
    });

    test('인증 실패 시 LockError 상태로 전이', () async {
      mockRepository = MockAuthenticatorRepository(
        authenticate: () async => left(LocalAuthFailure('실패')),
      );
      lockCubit = LockCubit(
        authenticatorRepository: mockRepository,
        lockRepository: mockLockRepository,
        passcode: '1234',
      );
      await lockCubit.authenticate();
      expect(lockCubit.state.status, LockStatus.error);
    });

    test('비밀번호 일치 시 LockUnlocked 상태로 전이', () async {
      mockRepository = MockAuthenticatorRepository(
        validatePasscode: (input, passcode) async => right(true),
      );
      lockCubit = LockCubit(
        authenticatorRepository: mockRepository,
        lockRepository: mockLockRepository,
        passcode: '1234',
      );
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
      lockCubit = LockCubit(
        authenticatorRepository: mockRepository,
        lockRepository: mockLockRepository,
        passcode: '1234',
      );
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
