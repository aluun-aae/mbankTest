import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class APIRequester {
  APIRequester({
    this.baseUrl,
  });
  final String? baseUrl;

  late final baseOptions = BaseOptions(
    baseUrl: baseUrl ?? "https://vpic.nhtsa.dot.gov/api",
    headers: {},
    responseType: ResponseType.json,
    contentType: 'application/json; charset=utf-8',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  );

  Dio _init() {
    return Dio(
      baseOptions,
    );
  }

  String catchError(error) {
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.badResponse: //RESPONSE
          {
            debugPrint(
                '===================> error.response <===================');
            debugPrint(error.response.toString());
            if (error.response!.statusCode == 401) {
              return error.response!.data['message'];
            } else if (error.response!.statusCode == 429) {
              log(json.decode(error.response!.data)['message']);

              log(json.decode(error.response!.data)['errorDescription']);
              log("statusCode");
              return error.response!.data['message'];
            } else if (error.response!.statusCode == 422) {
              if (error.response
                  .toString()
                  .contains("Такое значение поля email уже существует")) {
                return error.response!.data['message'];
              }
            }
            // ignore: lines_longer_than_80_chars

            return error.response!.data['message'];
          }
        case DioErrorType.receiveTimeout: //RECEIVE_TIMEOUT
        case DioErrorType.connectionError:
          {
            return "1getErrors(ErrorsEnum.noInternetConnectionError)";
          }
        case DioErrorType.sendTimeout: //SEND_TIMEOUT
          {
            return "2getErrors(ErrorsEnum.noInternetConnectionError)";
          }
        case DioErrorType.unknown: //DEFAULT
          {
            return "3getErrors(ErrorsEnum.noInternetConnectionError)";
          }
        case DioErrorType.cancel: //CANCEL
          {
            return "4getErrors(ErrorsEnum.noInternetConnectionError)";
          }
        default:
          {
            return "5getErrors(ErrorsEnum.noInternetConnectionError)";
          }
      }
    } else {
      debugPrint(error.toString());
      return "6getErrors(ErrorsEnum.noInternetConnectionError";
    }
  }

  Future<Response> toGet(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
  }) async {
    try {
      Dio dio = _init();
      dio.options.headers = headers;
      return await dio.get(url,
          queryParameters: queryParameters, options: options);
    } catch (error) {
      log("312" + error.toString());
      throw catchError(error);
    }
  }

  Future<Response> toPost(
    String url, {
    dynamic dataParam,
    Options? options,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final dio = _init();
      dio.options.headers = headers;
      return await dio.post(url, data: dataParam, options: options);
    } catch (error) {
      throw catchError(error);
    }
  }

  Future<Response> toPostParamDynamic(
    String url, {
    dynamic dataParam,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final dio = _init();
      dio.options.headers = headers;
      return await dio.post(url, data: dataParam.toString());
    } catch (error) {
      throw catchError(error);
    }
  }

  Future<Response> toPut(
    String url, {
    dynamic dataParam,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final dio = _init();
      dio.options.headers = headers;
      return await dio.put(url, data: dataParam);
    } catch (error) {
      throw catchError(error);
    }
  }

  Future<Response> toDelete(
    String url, {
    Map<String, dynamic>? dataParam,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final dio = _init();
      dio.options.headers = headers;
      return await dio.delete(url, data: dataParam);
    } catch (error) {
      throw catchError(error);
    }
  }
}
