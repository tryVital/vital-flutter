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

Map<String, dynamic> _$WorkoutsResponseToJson(WorkoutsResponse instance) =>
    <String, dynamic>{
      'workouts': instance.workouts,
    };

Workout _$WorkoutFromJson(Map<String, dynamic> json) => Workout(
      userId: json['user_id'] as String,
      userKey: json['user_key'] as String,
      id: json['id'] as String,
      title: json['title'] as String?,
      timezoneOffset: json['timezone_offset'] as int?,
      averageHr: (json['average_hr'] as num?)?.toDouble(),
      maxHr: (json['max_hr'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      timeStart: json['time_start'] == null
          ? null
          : DateTime.parse(json['time_start'] as String),
      timeEnd: json['time_end'] == null
          ? null
          : DateTime.parse(json['time_end'] as String),
      calories: (json['calories'] as num?)?.toDouble(),
      sport: json['sport'] == null
          ? null
          : Sport.fromJson(json['sport'] as Map<String, dynamic>),
      hrZones: (json['hr_zones'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          const [],
      movingTime: json['moving_time'] as int?,
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
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkoutToJson(Workout instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_key': instance.userKey,
      'id': instance.id,
      'title': instance.title,
      'timezone_offset': instance.timezoneOffset,
      'average_hr': instance.averageHr,
      'max_hr': instance.maxHr,
      'distance': instance.distance,
      'time_start': instance.timeStart?.toIso8601String(),
      'time_end': instance.timeEnd?.toIso8601String(),
      'calories': instance.calories,
      'sport': instance.sport,
      'hr_zones': instance.hrZones,
      'moving_time': instance.movingTime,
      'total_elevation_gain': instance.totalElevationGain,
      'elev_high': instance.elevHigh,
      'elev_low': instance.elevLow,
      'average_speed': instance.averageSpeed,
      'max_speed': instance.maxSpeed,
      'average_watts': instance.averageWatts,
      'device_watts': instance.deviceWatts,
      'max_watts': instance.maxWatts,
      'weighted_average_watts': instance.weightedAverageWatts,
      'map': instance.map,
      'provider_id': instance.providerId,
      'source': instance.source,
    };

Sport _$SportFromJson(Map<String, dynamic> json) => Sport(
      json['id'] as int,
      json['name'] as String,
    );

Map<String, dynamic> _$SportToJson(Sport instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MapData _$MapDataFromJson(Map<String, dynamic> json) => MapData(
      id: json['id'] as String,
      polyline: json['polyline'] as String?,
      summaryPolyline: json['summary_polyline'] as String?,
    );

Map<String, dynamic> _$MapDataToJson(MapData instance) => <String, dynamic>{
      'id': instance.id,
      'polyline': instance.polyline,
      'summary_polyline': instance.summaryPolyline,
    };

WorkoutStreamResponse _$WorkoutStreamResponseFromJson(
        Map<String, dynamic> json) =>
    WorkoutStreamResponse(
      time: (json['time'] as List<dynamic>?)?.map((e) => e as int).toList() ??
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

Map<String, dynamic> _$WorkoutStreamResponseToJson(
        WorkoutStreamResponse instance) =>
    <String, dynamic>{
      'time': instance.time,
      'cadence': instance.cadence,
      'altitude': instance.altitude,
      'velocity_smooth': instance.velocitySmooth,
      'heartrate': instance.heartrate,
      'lat': instance.lat,
      'lng': instance.lng,
      'distance': instance.distance,
      'power': instance.power,
      'resistance': instance.resistance,
    };
