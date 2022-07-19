import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:chopper/chopper.dart';

class HttpRequestLoggingInterceptor extends HttpLoggingInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) {
    chopperLogger.info('--> ${request.method} ${request.url}');
    print('--> ${request.method} ${request.url}');

    request.headers.forEach((k, v) {
      print('$k: $v');
    });

    String? bytes;
    if (request is http.Request) {
      if (request.body.isNotEmpty) {
        print(request.body);
      }
    }

    return super.onRequest(request);
  }

  @override
  FutureOr<Response> onResponse(Response response) {
    final base = response.base.request!;
    chopperLogger.info('<-- ${response.statusCode} ${base.url}');
    print('<-- ${response.statusCode} ${base.url}');

    response.base.headers.forEach((k, v) => chopperLogger.info('$k: $v'));

    String? bytes;
    if (response.base is http.Response) {
      final resp = response.base as http.Response;
      if (resp.body.isNotEmpty) {
        print(resp.body);
        bytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }

    print('--> END ${base.method}$bytes');
    //Fimber.i('--> END ${base.method}$bytes');
    return response;
  }
}
