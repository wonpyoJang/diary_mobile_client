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
      return left(HttpFailure(message: e.toString()));
    } catch (e) {
      return left(HttpFailure(message: e.toString()));
    }

    return right(HttpResponse(data: response.data as Map<String, dynamic>));
  }
}
