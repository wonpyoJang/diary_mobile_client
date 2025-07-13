import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:diary_mobile_client/src/core/media/infrastructure/interfaces/i_media_info_local_provider.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@LazySingleton(as: IMeidaInfoLocalProvider)
class MediaInfoLocalProvider implements IMeidaInfoLocalProvider {
  final Logger _logger = Logger();

  @override
  Future<Either<LocalFailure, List<XFile>>> selectMedias() async {
    late List<XFile> medias;

    final ImagePicker picker = ImagePicker();

    try {
      _logger.d('미디어 선택 시작');
      medias = await picker.pickMultipleMedia();
      _logger.d('미디어 선택 완료: ${medias.length}개 파일');
    } on PlatformException catch (e) {
      _logger.e('PlatformException 발생: ${e.code} - ${e.message}');
      // 플랫폼별 예외 처리
      switch (e.code) {
        case 'camera_access_denied':
          return left(const LocalFailure(message: "카메라 접근 권한이 거부되었습니다."));
        case 'photo_access_denied':
          return left(const LocalFailure(message: "사진 라이브러리 접근 권한이 거부되었습니다."));
        case 'camera_not_available':
          return left(const LocalFailure(message: "카메라를 사용할 수 없습니다."));
        case 'photo_library_not_available':
          return left(const LocalFailure(message: "사진 라이브러리를 사용할 수 없습니다."));
        case 'permission_denied':
          return left(const LocalFailure(message: "필요한 권한이 거부되었습니다."));
        case 'user_cancelled':
          return left(const LocalFailure(message: "사용자가 미디어 선택을 취소했습니다."));
        case 'no_media_selected':
          return left(const LocalFailure(message: "선택된 미디어가 없습니다."));
        case 'file_too_large':
          return left(const LocalFailure(message: "파일 크기가 너무 큽니다."));
        case 'unsupported_file_type':
          return left(const LocalFailure(message: "지원하지 않는 파일 형식입니다."));
        default:
          return left(
              LocalFailure(message: "미디어 선택 중 오류가 발생했습니다. (${e.message})"));
      }
    } on StateError catch (e) {
      _logger.e('StateError 발생: ${e.message}');
      // 상태 관련 오류
      return left(LocalFailure(message: "잘못된 상태입니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      // 인수 관련 오류
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      // 일반적인 Exception 타입의 예외 처리
      return left(
          LocalFailure(message: "미디어 선택 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(const LocalFailure(message: "미디어 선택 중 알 수 없는 오류가 발생했습니다."));
    }

    return right(medias);
  }
}
