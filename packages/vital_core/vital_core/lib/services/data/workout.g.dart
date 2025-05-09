// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutsResponse _$WorkoutsResponseFromJson(Map<String, dynamic> json) =>
    WorkoutsResponse(
      (json['workouts'] as List<dynamic>)
          .map((e) => Workout.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      userId: json['user_id'] as String,
      id: json['id'] as String,
      title: json['title'] as String?,
      timezoneOffset: (json['timezone_offset'] as num?)?.toInt(),
      averageHr: (json['average_hr'] as num?)?.toDouble(),
      maxHr: (json['max_hr'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      timeStart: DateTime.parse(json['time_start'] as String),
      timeEnd: DateTime.parse(json['time_end'] as String),
      calories: (json['calories'] as num?)?.toDouble(),
      sport: json['sport'] == null
          ? null
          : Sport.fromJson(json['sport'] as Map<String, dynamic>),
      hrZones: (json['hr_zones'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          const [],
      movingTime: (json['moving_time'] as num?)?.toInt(),
      totalElevationGain: (json['total_elevation_gain'] as num?)?.toDouble(),
      elevHigh: (json['elev_high'] as num?)?.toDouble(),
      elevLow: (json['elev_low'] as num?)?.toDouble(),
      averageSpeed: (json['average_speed'] as num?)?.toDouble(),
      maxSpeed: (json['max_speed'] as num?)?.toDouble(),
      averageWatts: (json['average_watts'] as num?)?.toDouble(),
      deviceWatts: (json['device_watts'] as num?)?.toDouble(),
      maxWatts: (json['max_watts'] as num?)?.toDouble(),
      weightedAverageWatts:
          (json['weighted_average_watts'] as num?)?.toDouble(),
      map: json['map'] == null
          ? null
          : MapData.fromJson(json['map'] as Map<String, dynamic>),
      providerId: json['provider_id'] as String?,
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );

Sport _$SportFromJson(Map<String, dynamic> json) => Sport(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

MapData _$MapDataFromJson(Map<String, dynamic> json) => MapData(
      id: json['id'] as String,
      polyline: json['polyline'] as String?,
      summaryPolyline: json['summary_polyline'] as String?,
    );

WorkoutStreamResponse _$WorkoutStreamResponseFromJson(
        Map<String, dynamic> json) =>
    WorkoutStreamResponse(
      time: (json['time'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      lat: (json['lat'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      lng: (json['lng'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      altitude: (json['altitude'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      velocitySmooth: (json['velocity_smooth'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      heartrate: (json['heartrate'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      cadence: (json['cadence'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      distance: (json['distance'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      power: (json['power'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
      resistance: (json['resistance'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [],
    );
