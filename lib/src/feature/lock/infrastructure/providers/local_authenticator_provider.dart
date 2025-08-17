import 'package:diary_mobile_client/src/feature/lock/domain/failures/local_auth_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:local_auth/local_auth.dart';
import 'interfaces/i_local_authenticator_provider.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:injectable/injectable.dart';

@Injectable(as: IAuthenticatorProvider)
class LocalAuthenticatorProvider implements IAuthenticatorProvider {
  @override
  Future<Either<LocalAuthFailure, bool>> authenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(useErrorDialogs: false),
      );
      return right(didAuthenticate);
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        return left(LocalAuthFailure('이 기기에서는 생체 인증을 지원하지 않습니다.'));
      } else if (e.code == auth_error.notEnrolled) {
        return left(LocalAuthFailure('생체 인증이 등록되어 있지 않습니다.'));
      } else if (e.code == auth_error.lockedOut) {
        return left(LocalAuthFailure('인증 시도가 너무 많아 잠금 상태입니다. 잠시 후 다시 시도해주세요.'));
      } else if (e.code == auth_error.permanentlyLockedOut) {
        return left(LocalAuthFailure(
            '인증 시도가 너무 많아 영구적으로 잠금되었습니다. 기기 설정에서 잠금을 해제해주세요.'));
      } else if (e.code == auth_error.passcodeNotSet) {
        return left(LocalAuthFailure('기기에 잠금(비밀번호/패턴 등)이 설정되어 있지 않습니다.'));
      } else if (e.code == auth_error.otherOperatingSystem) {
        return left(LocalAuthFailure('지원하지 않는 운영체제입니다.'));
      } else if (e.code == 'userCanceled') {
        return left(LocalAuthFailure('사용자가 인증을 취소했습니다.'));
      } else if (e.code == 'userFallback') {
        return left(LocalAuthFailure('사용자가 다른 인증 방법을 선택했습니다.'));
      } else if (e.code == 'biometryNotAvailable') {
        return left(LocalAuthFailure('생체 인증 하드웨어를 찾을 수 없습니다.'));
      } else if (e.code == 'biometryNotEnrolled') {
        return left(LocalAuthFailure('생체 인증이 등록되어 있지 않습니다.'));
      } else if (e.code == 'biometryLockout') {
        return left(LocalAuthFailure('생체 인증이 잠금 상태입니다. 기기 설정에서 잠금을 해제해주세요.'));
      } else {
        return left(LocalAuthFailure(e.message ?? '알 수 없는 인증 오류'));
      }
    } catch (e) {
      return left(LocalAuthFailure('예상치 못한 오류가 발생했습니다: ${e.toString()}'));
    }
  }

  @override
  Future<Either<LocalAuthFailure, bool>> validatePasscode(
      String input, String? passcode) async {
    if (input == passcode) {
      return right(true);
    } else {
      return left(LocalAuthFailure('비밀번호가 일치하지 않습니다.'));
    }
  }
}
