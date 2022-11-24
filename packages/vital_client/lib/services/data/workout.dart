import 'package:json_annotation/json_annotation.dart';
import 'package:vital_client/services/data/user.dart';
part 'workout.g.dart';

@JsonSerializable(createToJson: false)
class WorkoutsResponse {
  List<Workout> workouts;

  WorkoutsResponse(this.workouts);

  factory WorkoutsResponse.fromJson(Map<String, dynamic> json) => _$WorkoutsResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class Workout {
  @JsonKey(name: 'user_id')
  String userId;
  @JsonKey(name: 'user_key')
  String userKey;
  String id;
  String? title;
  @JsonKey(name: 'timezone_offset')
  int? timezoneOffset;
  @JsonKey(name: 'average_hr')
  double? averageHr;
  @JsonKey(name: 'max_hr')
  double? maxHr;
  double? distance;
  @JsonKey(name: 'time_start')
  DateTime? timeStart;
  @JsonKey(name: 'time_end')
  DateTime? timeEnd;
  double? calories;
  Sport? sport;
  @JsonKey(name: 'hr_zones')
  List<Object> hrZones;
  @JsonKey(name: 'moving_time')
  int? movingTime;
  @JsonKey(name: 'total_elevation_gain')
  double? totalElevationGain;
  @JsonKey(name: 'elev_high')
  double? elevHigh;
  @JsonKey(name: 'elev_low')
  double? elevLow;
  @JsonKey(name: 'average_speed')
  double? averageSpeed;
  @JsonKey(name: 'max_speed')
  double? maxSpeed;
  @JsonKey(name: 'average_watts')
  double? averageWatts;
  @JsonKey(name: 'device_watts')
  double? deviceWatts;
  @JsonKey(name: 'max_watts')
  double? maxWatts;
  @JsonKey(name: 'weighted_average_watts')
  double? weightedAverageWatts;
  MapData? map;
  @JsonKey(name: 'provider_id')
  String? providerId;
  Source? source;

  Workout({
    required this.userId,
    required this.userKey,
    required this.id,
    this.title,
    this.timezoneOffset,
    this.averageHr,
    this.maxHr,
    this.distance,
    this.timeStart,
    this.timeEnd,
    this.calories,
    this.sport,
    this.hrZones = const [],
    this.movingTime,
    this.totalElevationGain,
    this.elevHigh,
    this.elevLow,
    this.averageSpeed,
    this.maxSpeed,
    this.averageWatts,
    this.deviceWatts,
    this.maxWatts,
    this.weightedAverageWatts,
    this.map,
    this.providerId,
    this.source,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);
}

@JsonSerializable(createToJson: false)
class Sport {
  int id;
  String name;

  Sport(this.id, this.name);

  factory Sport.fromJson(Map<String, dynamic> json) => _$SportFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapData {
  String id;
  String? polyline;
  @JsonKey(name: 'summary_polyline')
  String? summaryPolyline;

  MapData({
    required this.id,
    this.polyline,
    this.summaryPolyline,
  });

  factory MapData.fromJson(Map<String, dynamic> json) => _$MapDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class WorkoutStreamResponse {
  List<int> time;
  List<double> cadence;
  List<double> altitude;
  @JsonKey(name: 'velocity_smooth')
  List<double> velocitySmooth;
  List<double> heartrate;
  List<double> lat;
  List<double> lng;
  List<double> distance;
  List<double> power;
  List<double> resistance;

  WorkoutStreamResponse({
    this.time = const [],
    this.lat = const [],
    this.lng = const [],
    this.altitude = const [],
    this.velocitySmooth = const [],
    this.heartrate = const [],
    this.cadence = const [],
    this.distance = const [],
    this.power = const [],
    this.resistance = const [],
  });

  factory WorkoutStreamResponse.fromJson(Map<String, dynamic> json) => _$WorkoutStreamResponseFromJson(json);
}
