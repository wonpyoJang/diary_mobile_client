import 'package:diary_mobile_client/src/core/http_client/http_failure.dart';
import 'package:diary_mobile_client/src/core/http_client/http_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

@singleton
class HttpClient {
  final Dio dio;

  HttpClient(this.dio);

  Future<Either<HttpFailure, HttpResponse>> request(
      {required String path,
      String? prefix = "",
      required HttpMethod method,
      Map<String, dynamic>? body}) async {
    late Response response;

    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      switch (method) {
        case HttpMethod.get:
          response = await dio.get(path);
          break;
        case HttpMethod.post:
          response = await dio.post(path, data: encodedBody);
          break;
        case HttpMethod.put:
          response = await dio.put(path, data: encodedBody);
          break;
        case HttpMethod.delete:
          response = await dio.delete(path);
          break;
      }
    } on DioException catch (e) {
      String message = '알 수 없는 네트워크 오류가 발생했습니다.';
      String? code;
      dynamic details = e.message;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          message = '서버 연결 시간이 초과되었습니다.';
          code = 'CONNECTION_TIMEOUT';
          break;
        case DioExceptionType.sendTimeout:
          message = '요청 전송 시간이 초과되었습니다.';
          code = 'SEND_TIMEOUT';
          break;
        case DioExceptionType.receiveTimeout:
          message = '응답 대기 시간이 초과되었습니다.';
          code = 'RECEIVE_TIMEOUT';
          break;
        case DioExceptionType.badCertificate:
          message = '서버 인증서 오류가 발생했습니다.';
          code = 'BAD_CERTIFICATE';
          break;
        case DioExceptionType.badResponse:
          message = '서버에서 잘못된 응답을 반환했습니다.';
          code = 'BAD_RESPONSE';
          details = {
            'statusCode': e.response?.statusCode,
            'data': e.response?.data,
            'headers': e.response?.headers.map
          };
          break;
        case DioExceptionType.cancel:
          message = '요청이 취소되었습니다.';
          code = 'CANCEL';
          break;
        case DioExceptionType.connectionError:
          message = '네트워크 연결 오류가 발생했습니다.';
          code = 'CONNECTION_ERROR';
          break;
        case DioExceptionType.unknown:
          message = '알 수 없는 오류가 발생했습니다.';
          code = 'UNKNOWN';
          break;
      }
      return left(HttpFailure(message: message, code: code, details: details));
    } on TypeError catch (e) {
      return left(HttpFailure(
          message: '응답 데이터 타입 오류', code: 'TYPE_ERROR', details: e.toString()));
    } catch (e) {
      return left(HttpFailure(
          message: '예상치 못한 오류 발생', code: 'UNEXPECTED', details: e.toString()));
    }

    try {
      return right(HttpResponse(data: response.data as Map<String, dynamic>));
    } on TypeError catch (e) {
      return left(HttpFailure(
          message: '응답 데이터 타입 오류', code: 'TYPE_ERROR', details: e.toString()));
    }
  }
}
