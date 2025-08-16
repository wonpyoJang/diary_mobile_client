import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/version_failure.dart';
import 'interfaces/i_version_local_provider.dart';
import 'package:flutter/services.dart';

@LazySingleton(as: IVersionLocalProvider)
class VersionLocalProvider implements IVersionLocalProvider {
  VersionLocalProvider();

  @override
  Future<Either<VersionFailure, String>> getVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return right(packageInfo.version);
    } on PlatformException catch (e) {
      return left(VersionFailure('플랫폼 오류:  ${e.message}'));
    } on MissingPluginException catch (e) {
      return left(VersionFailure('플러그인 오류: ${e.message}'));
    } catch (e) {
      return left(VersionFailure('버전 정보를 가져올 수 없습니다. (${e.toString()})'));
    }
  }

  @override
  Future<Either<VersionFailure, String>> getBuildNumber() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return right(packageInfo.buildNumber);
    } on PlatformException catch (e) {
      return left(VersionFailure('플랫폼 오류: ${e.message}'));
    } on MissingPluginException catch (e) {
      return left(VersionFailure('플러그인 오류: ${e.message}'));
    } catch (e) {
      return left(VersionFailure('빌드 넘버를 가져올 수 없습니다. (${e.toString()})'));
    }
  }
}
