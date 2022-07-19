import 'package:chopper/chopper.dart';

class HttpApiKeyInterceptor extends HeadersInterceptor {
  HttpApiKeyInterceptor(String apiKey) : super({"x-vital-api-key": apiKey});
}
