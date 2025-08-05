import 'dart:io';
import 'dart:typed_data';
import 'package:diary_mobile_client/src/core/failure/local_failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

@singleton
class FileManager {
  final Logger _logger = Logger();

  /// 이미지(또는 파일) 바이트를 앱 전용 디렉토리에 저장
  /// [imageBytes] : 저장할 파일의 바이트 데이터
  /// [tempPath] : 저장할 파일명
  /// 성공 시 저장된 파일의 경로 반환, 실패 시 LocalFailure 반환
  Future<Either<LocalFailure, File>> saveImage(
      Uint8List imageBytes, String tempPath) async {
    try {
      _logger.d('이미지 저장 시작: $tempPath');

      // 앱의 영구 저장소(사용자 문서 디렉토리)에 저장
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      // 파일의 전체 경로를 앱 문서 디렉토리 하위로 지정
      final file = File('$path/$tempPath');

      // 파일 저장
      await file.writeAsBytes(imageBytes);

      _logger.d('이미지 저장 완료: ${file.path}');
      return right(file);
    } on FileSystemException catch (e) {
      _logger.e('FileSystemException 발생: ${e.message}');
      return left(LocalFailure(message: "파일 시스템 오류가 발생했습니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "이미지 저장 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(const LocalFailure(message: "이미지 저장 중 알 수 없는 오류가 발생했습니다."));
    }
  }

  /// 여러 파일 저장
  /// [files] : 저장할 파일 객체 리스트
  /// 여러 이미지를 saveImage를 활용하여 저장하는 메소드
  /// [images] : 저장할 이미지 바이트 리스트
  /// [fileNames] : 각 이미지에 대응하는 파일명 리스트
  /// 성공 시 Unit 반환, 실패 시 LocalFailure 반환
  Future<Either<LocalFailure, List<File>>> saveMultipleImages(
      List<Uint8List> images, List<String> fileNames) async {
    if (images.length != fileNames.length) {
      return left(const LocalFailure(message: "이미지와 파일명 개수가 일치하지 않습니다."));
    }

    List<Either<LocalFailure, File>> savedImageFiles =
        await Future.wait(images.map((e) async {
      final i = images.indexOf(e);
      final result = await saveImage(e, fileNames[i]);

      return result;
    }));

    if (savedImageFiles.any((e) => e.isLeft())) {
      return left(savedImageFiles
          .firstWhere((e) => e.isLeft())
          .getLeft()
          .getOrElse(
              () => const LocalFailure(message: "이미지 저장 중 오류가 발생했습니다.")));
    }

    return right(
        savedImageFiles.map((e) => e.fold((l) => File(""), (r) => r)).toList());
  }

  /// 파일 삭제
  /// [file] : 삭제할 파일 객체
  Future<Either<LocalFailure, Unit>> deleteFile(File file) async {
    try {
      _logger.d('파일 삭제 시작: ${file.path}');

      if (await file.exists()) {
        await file.delete();
        _logger.d('파일 삭제 완료: ${file.path}');
      } else {
        _logger.w('삭제할 파일이 존재하지 않음: ${file.path}');
      }

      return right(unit);
    } on FileSystemException catch (e) {
      _logger.e('FileSystemException 발생: ${e.message}');
      return left(LocalFailure(message: "파일 시스템 오류가 발생했습니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "파일 삭제 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(const LocalFailure(message: "파일 삭제 중 알 수 없는 오류가 발생했습니다."));
    }
  }

  /// 파일 불러오기
  /// [file] : 불러올 파일 객체
  Future<Either<LocalFailure, List<int>>> readFile(File file) async {
    try {
      _logger.d('파일 읽기 시작: ${file.path}');

      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        _logger.d('파일 읽기 완료: ${file.path} (${bytes.length} bytes)');
        return right(bytes);
      } else {
        _logger.w('파일이 존재하지 않음: ${file.path}');
        return left(const LocalFailure(message: "파일이 존재하지 않습니다."));
      }
    } on FileSystemException catch (e) {
      _logger.e('FileSystemException 발생: ${e.message}');
      return left(LocalFailure(message: "파일 시스템 오류가 발생했습니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "파일 읽기 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(const LocalFailure(message: "파일 읽기 중 알 수 없는 오류가 발생했습니다."));
    }
  }

  /// 파일 존재 여부 확인
  /// [file] : 확인할 파일 객체
  Future<Either<LocalFailure, bool>> fileExists(File file) async {
    try {
      _logger.d('파일 존재 여부 확인: ${file.path}');
      final exists = await file.exists();
      _logger.d('파일 존재 여부: ${file.path} -> $exists');
      return right(exists);
    } on FileSystemException catch (e) {
      _logger.e('FileSystemException 발생: ${e.message}');
      return left(LocalFailure(message: "파일 시스템 오류가 발생했습니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "파일 존재 여부 확인 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(
          const LocalFailure(message: "파일 존재 여부 확인 중 알 수 없는 오류가 발생했습니다."));
    }
  }

  /// 파일 생성
  /// [path] : 생성할 파일 경로
  Future<Either<LocalFailure, File>> createFile(String path) async {
    try {
      _logger.d('파일 생성 시작: $path');
      final file = File(path);

      // 디렉토리가 존재하지 않으면 생성
      final directory = file.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // 파일이 존재하지 않으면 생성
      if (!await file.exists()) {
        await file.create();
        _logger.d('파일 생성 완료: ${file.path}');
      } else {
        _logger.w('파일이 이미 존재함: ${file.path}');
      }

      return right(file);
    } on FileSystemException catch (e) {
      _logger.e('FileSystemException 발생: ${e.message}');
      return left(LocalFailure(message: "파일 시스템 오류가 발생했습니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "파일 생성 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(const LocalFailure(message: "파일 생성 중 알 수 없는 오류가 발생했습니다."));
    }
  }

  /// 파일 복사
  /// [sourceFile] : 원본 파일 객체
  /// [targetPath] : 대상 파일 경로
  Future<Either<LocalFailure, File>> copyFile(
      File sourceFile, String targetPath) async {
    try {
      _logger.d('파일 복사 시작: ${sourceFile.path} -> $targetPath');

      if (await sourceFile.exists()) {
        final targetFile = await sourceFile.copy(targetPath);
        _logger.d('파일 복사 완료: ${targetFile.path}');
        return right(targetFile);
      } else {
        _logger.w('원본 파일이 존재하지 않음: ${sourceFile.path}');
        return left(const LocalFailure(message: "원본 파일이 존재하지 않습니다."));
      }
    } on FileSystemException catch (e) {
      _logger.e('FileSystemException 발생: ${e.message}');
      return left(LocalFailure(message: "파일 시스템 오류가 발생했습니다. (${e.message})"));
    } on ArgumentError catch (e) {
      _logger.e('ArgumentError 발생: ${e.message}');
      return left(LocalFailure(message: "잘못된 인수가 전달되었습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "파일 복사 중 오류가 발생했습니다. (${e.toString()})"));
    } catch (e) {
      _logger.e('알 수 없는 예외 발생: ${e.toString()}');
      return left(const LocalFailure(message: "파일 복사 중 알 수 없는 오류가 발생했습니다."));
    }
  }
}
