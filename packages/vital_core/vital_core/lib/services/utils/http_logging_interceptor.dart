import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

/// Matches the previous logging output while using the new interceptor API.
class HttpRequestLoggingInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    chopperLogger.info('--> ${request.method} ${request.url}');
    request.headers.forEach((k, v) {
      chopperLogger.info('$k: $v');
    });

    final body = request.body;
    if (body is String && body.isNotEmpty) {
      chopperLogger.info(body);
    }

    final response = await chain.proceed(request);

    final base = response.base.request;
    chopperLogger.info('<-- ${response.statusCode} ${base?.url}');

    response.base.headers.forEach((k, v) => chopperLogger.info('$k: $v'));

    String? bytes;
    if (response.base is http.Response) {
      final resp = response.base as http.Response;
      if (resp.body.isNotEmpty) {
        chopperLogger.info(resp.body);
        bytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }

    chopperLogger.info('--> END ${base?.method}$bytes');
    return response;
  }
}
