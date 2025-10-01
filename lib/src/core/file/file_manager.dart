import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import '../failure/local_failure.dart';

@singleton
class FileManager {
  final Logger _logger = Logger();

  /// 이미지(또는 파일) 바이트를 지정된 파일에 저장
  /// [tmpFile] : 저장할 임시 파일
  /// 성공 시 저장된 파일의 경로 반환, 실패 시 LocalFailure 반환
  Future<Either<LocalFailure, File>> saveImage(XFile tmpFile) async {
    final directoryResult = await _getApplicationDirectory();
    return directoryResult.fold(
      (failure) => left(failure),
      (directory) async {
        final fileResult = await _createTargetFile(tmpFile, directory);
        return fileResult.fold(
          (failure) => left(failure),
          (file) async {
            return await _writeFileContent(tmpFile, file);
          },
        );
      },
    );
  }

  /// 앱 문서 디렉토리 가져오기
  Future<Either<LocalFailure, Directory>> _getApplicationDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return right(directory);
    } catch (e) {
      _logger.e('앱 문서 디렉토리 가져오기 실패: ${e.toString()}');
      return left(const LocalFailure(message: "앱 문서 디렉토리를 가져올 수 없습니다."));
    }
  }

  /// 대상 파일 생성
  Future<Either<LocalFailure, File>> _createTargetFile(
      XFile tmpFile, Directory directory) async {
    try {
      final fileName = tmpFile.name;
      final file = File('${directory.path}/$fileName');
      return right(file);
    } catch (e) {
      _logger.e('대상 파일 생성 실패: ${e.toString()}');
      return left(const LocalFailure(message: "대상 파일을 생성할 수 없습니다."));
    }
  }

  /// 파일 내용 쓰기
  Future<Either<LocalFailure, File>> _writeFileContent(
      XFile tmpFile, File targetFile) async {
    try {
      _logger.d('이미지 저장 시작: ${tmpFile.path}');

      final imageBytes = await tmpFile.readAsBytes();
      final saveFile = await targetFile.writeAsBytes(imageBytes);

      _logger.d('이미지 저장 완료: ${saveFile.path}');
      return right(saveFile);
    } on FileSystemException catch (e) {
      _logger.e('FileSystemException 발생: ${e.message}');
      return left(LocalFailure(message: "파일 시스템 오류가 발생했습니다. (${e.message})"));
    } on Exception catch (e) {
      _logger.e('Exception 발생: ${e.toString()}');
      return left(
          LocalFailure(message: "이미지 저장 중 오류가 발생했습니다. (${e.toString()})"));
    }
  }

  /// 여러 파일 저장
  /// 여러 이미지를 saveImage를 활용하여 저장하는 메소드
  /// [tmpFiles] : 저장할 임시 파일 리스트
  /// 성공 시 저장된 파일 리스트 반환, 실패 시 LocalFailure 반환
  Future<Either<LocalFailure, List<File>>> saveMultipleImages(
      List<XFile> tmpFiles) async {
    if (tmpFiles.isEmpty) {
      return right([]);
    }

    final results =
        await Future.wait(tmpFiles.map((tmpFile) => saveImage(tmpFile)));

    // 성공과 실패 결과를 분리
    final successes = <File>[];
    final failures = <LocalFailure>[];

    for (final result in results) {
      result.fold(
        (failure) => failures.add(failure),
        (file) => successes.add(file),
      );
    }

    // 실패가 있으면 첫 번째 실패 반환
    if (failures.isNotEmpty) {
      return left(failures.first);
    }

    return right(successes);
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
