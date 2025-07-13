import 'dart:io';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class ImagePickerClient {
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();

  Future<Either<LocalFailure, List<XFile>>> pickMultipleMedia() async {
    try {
      _logger.d('이미지 선택 시작');
      final List<XFile> images = await _picker.pickMultiImage();
      _logger.d('이미지 선택 완료: ${images.length}개 파일');
      return right(images);
    } on PlatformException catch (e) {
      _logger.e('PlatformException 발생: ${e.code} - ${e.message}');

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
          return left(const LocalFailure(message: "사용자가 이미지 선택을 취소했습니다."));
        case 'no_media_selected':
          return left(const LocalFailure(message: "선택된 이미지가 없습니다."));
        case 'file_too_large':
          return left(const LocalFailure(message: "파일 크기가 너무 큽니다."));
        case 'unsupported_file_type':
          return left(const LocalFailure(message: "지원하지 않는 파일 형식입니다."));
        default:
          return left(
              LocalFailure(message: "이미지 선택 중 오류가 발생했습니다. (${e.message})"));
      }
    } on StateError catch (e) {
      _logger.e('StateError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 상태입니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "이미지 선택 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(const LocalFailure(message: "이미지 선택 중 알 수 없는 오류가 발생했습니다."));
    }
  }
}
