import 'package:json_annotation/json_annotation.dart';
import 'package:vital_core/services/data/source.dart';
part 'workout.g.dart';

@JsonSerializable(createToJson: false)
class WorkoutsResponse {
  List<Workout> workouts;

  WorkoutsResponse(this.workouts);

  factory WorkoutsResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutsResponseFromJson(json);
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Workout {
  String userId;
  String id;
  String? title;
  int? timezoneOffset;
  double? averageHr;
  double? maxHr;
  double? distance;
  DateTime timeStart;
  DateTime timeEnd;
  double? calories;
  Sport? sport;
  List<Object> hrZones;
  int? movingTime;
  double? totalElevationGain;
  double? elevHigh;
  double? elevLow;
  double? averageSpeed;
  double? maxSpeed;
  double? averageWatts;
  double? deviceWatts;
  double? maxWatts;
  double? weightedAverageWatts;
  MapData? map;
  String? providerId;
  Source source;

  Workout({
    required this.userId,
    required this.id,
    this.title,
    this.timezoneOffset,
    this.averageHr,
    this.maxHr,
    this.distance,
    required this.timeStart,
    required this.timeEnd,
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
    required this.source,
  });

  factory Workout.fromJson(Map<String, dynamic> json) =>
      _$WorkoutFromJson(json);
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

  factory MapData.fromJson(Map<String, dynamic> json) =>
      _$MapDataFromJson(json);
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

  factory WorkoutStreamResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutStreamResponseFromJson(json);
}
