import 'package:chopper/chopper.dart';

// ignore: prefer_generic_function_type_aliases
typedef T JsonFactory<T>(Map<String, dynamic> json);

class NoContent {}

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, JsonFactory> factories;

  const JsonSerializableConverter(this.factories);

  T? _decodeMap<T>(Map<String, dynamic> values) {
    /// Get jsonFactory using Type parameters
    /// if not found or invalid, throw error or return null
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      /// throw serializer not found error;
      return null;
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => _decode<T>(v)).toList();

  dynamic _decode<T>(entity) {
    if (entity is Iterable) return _decodeList<T>(entity as List);

    if (entity is Map) return _decodeMap<T>(entity as Map<String, dynamic>);

    return entity;
  }

  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    if (ResultType == NoContent) {
      return response.copyWith<NoContent>(body: NoContent())
          as Response<ResultType>;
    }

    // use [JsonConverter] to decode json
    final jsonRes = super.convertResponse(response);

    return jsonRes.copyWith<ResultType>(body: _decode<Item>(jsonRes.body));
  }
}

/*class ComputeConverter extends Converter {
  ComputeConverter(this.converter);

  final JsonSerializableConverter converter;

  @override
  FutureOr<Request> convertRequest(Request request) {
    return converter.convertRequest(request);
  }

  @override
  FutureOr<Response<BodyType>> convertResponse<BodyType, InnerType>(Response response) {
    return compute((Response response) => converter.convertResponse<BodyType, InnerType>(response), response);
  }
}*/
