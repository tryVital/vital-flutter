import 'package:json_annotation/json_annotation.dart';

part 'testkits.g.dart';

@JsonSerializable()
class CreateOrderRequest {
  @JsonKey(name: 'testkit_id')
  String testkitId;
  @JsonKey(name: 'patient_address')
  PatientAddress patientAddress;
  @JsonKey(name: 'patient_details')
  PatientDetails patientDetails;
  @JsonKey(name: 'user_id')
  String userId;
  //Physician physician;//,\n  \"inbound_tracking_number\": \"dolor laboris commodo\",\n  \"outbound_tracking_number\": \"amet dolor do of\",\n  \"outbound_courier\": \"et cupidatat cillum nisi\",\n  \"inbound_courier\": \"consectetur q\"\n}

  CreateOrderRequest({
    required this.testkitId,
    required this.userId,
    required this.patientAddress,
    required this.patientDetails,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

@JsonSerializable()
class OrderResponse {
  String? status;
  String? message;
  OrderData? order;

  OrderResponse({
    this.status,
    this.order,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) => _$OrderResponseFromJson(json);
}

@JsonSerializable()
class OrdersResponse {
  List<OrderData> orders;

  OrdersResponse({
    this.orders = const [],
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => _$OrdersResponseFromJson(json);
}

@JsonSerializable()
class TestkitsResponse {
  List<Testkit> testkits;

  TestkitsResponse({
    this.testkits = const [],
  });

  factory TestkitsResponse.fromJson(Map<String, dynamic> json) => _$TestkitsResponseFromJson(json);
}

@JsonSerializable()
class OrderData {
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'user_key')
  String? userKey;
  String? id;
  @JsonKey(name: 'team_id')
  String? teamId;
  @JsonKey(name: 'created_on')
  DateTime? createdOn;
  @JsonKey(name: 'updated_on')
  DateTime? updatedOn;
  String? status;
  @JsonKey(name: 'testkit_id')
  String? testkitId;
  Testkit? testkit;
  @JsonKey(name: 'inbound_tracking_number')
  String? inboundTrackingNumber;
  @JsonKey(name: 'outbound_tracking_number')
  String? outboundTrackingNumber;
  @JsonKey(name: 'inbound_tracking_url')
  String? inboundTrackingUrl;
  @JsonKey(name: 'outbound_tracking_url')
  String? outboundTrackingUrl;
  @JsonKey(name: 'outbound_courier')
  String? outboundCourier;
  @JsonKey(name: 'inbound_courier')
  String? inboundCourier;
  @JsonKey(name: 'patient_address')
  PatientAddress? patientAddress;
  @JsonKey(name: 'patient_details')
  PatientDetails? patientDetails;
  @JsonKey(name: 'sample_id')
  String? sampleId;

  OrderData({
    this.userId,
    this.userKey,
    this.id,
    this.teamId,
    this.createdOn,
    this.updatedOn,
    this.status,
    this.testkitId,
    this.testkit,
    this.inboundTrackingNumber,
    this.outboundTrackingNumber,
    this.inboundTrackingUrl,
    this.outboundTrackingUrl,
    this.outboundCourier,
    this.inboundCourier,
    this.patientAddress,
    this.patientDetails,
    this.sampleId,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => _$OrderDataFromJson(json);
}

@JsonSerializable()
class Testkit {
  String id;
  String name;
  String description;
  List<TestkitMarker> markers;
  @JsonKey(name: 'turnaround_time_lower')
  int? turnaroundTimeLower;
  @JsonKey(name: 'turnaround_time_upper')
  int? turnaroundTimeUpper;
  double? price;

  Testkit({
    required this.id,
    required this.name,
    required this.description,
    this.markers = const [],
    this.turnaroundTimeLower,
    this.turnaroundTimeUpper,
    this.price,
  });

  factory Testkit.fromJson(Map<String, dynamic> json) => _$TestkitFromJson(json);
}

@JsonSerializable()
class TestkitMarker {
  String name;
  String slug;
  String? description;

  TestkitMarker({
    required this.name,
    required this.slug,
    this.description,
  });

  factory TestkitMarker.fromJson(Map<String, dynamic> json) => _$TestkitMarkerFromJson(json);
}

@JsonSerializable()
class PatientAddress {
  @JsonKey(name: 'receiver_name')
  String? receiverName;
  String? street;
  @JsonKey(name: 'street_number')
  String? streetNumber;
  String? city;
  String? state;
  String? zip;
  String? country;
  @JsonKey(name: 'phone_number')
  String? phoneNumber;

  PatientAddress({
    this.receiverName,
    this.street,
    this.streetNumber,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.phoneNumber,
  });

  factory PatientAddress.fromJson(Map<String, dynamic> json) => _$PatientAddressFromJson(json);

  Map<String, dynamic> toJson() => _$PatientAddressToJson(this);
}

@JsonSerializable()
class PatientDetails {
  DateTime? dob;
  String? gender;
  String? email;

  PatientDetails({
    this.dob,
    this.gender,
    this.email,
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) => _$PatientDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PatientDetailsToJson(this);
}
