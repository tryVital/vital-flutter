// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeseries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScalarSample _$ScalarSampleFromJson(Map<String, dynamic> json) => ScalarSample(
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num).toDouble(),
      type: json['type'] as String?,
      unit: json['unit'] as String,
      timezoneOffset: json['timezone_offset'] as int?,
    );

IntervalSample _$IntervalSampleFromJson(Map<String, dynamic> json) =>
    IntervalSample(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      value: (json['value'] as num).toDouble(),
      type: json['type'] as String?,
      unit: json['unit'] as String,
      timezoneOffset: json['timezone_offset'] as int?,
    );

BloodPressureSample _$BloodPressureSampleFromJson(Map<String, dynamic> json) =>
    BloodPressureSample(
      timestamp: DateTime.parse(json['timestamp'] as String),
      systolic: (json['systolic'] as num).toDouble(),
      diastolic: (json['diastolic'] as num).toDouble(),
      type: json['type'] as String?,
      unit: json['unit'] as String,
      timezoneOffset: json['timezone_offset'] as int?,
    );

GroupedScalarTimeseries _$GroupedScalarTimeseriesFromJson(
        Map<String, dynamic> json) =>
    GroupedScalarTimeseries(
      data: (json['data'] as List<dynamic>)
          .map((e) => ScalarSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );

GroupedIntervalTimeseries _$GroupedIntervalTimeseriesFromJson(
        Map<String, dynamic> json) =>
    GroupedIntervalTimeseries(
      data: (json['data'] as List<dynamic>)
          .map((e) => IntervalSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );

GroupedBloodPressureTimeseries _$GroupedBloodPressureTimeseriesFromJson(
        Map<String, dynamic> json) =>
    GroupedBloodPressureTimeseries(
      data: (json['data'] as List<dynamic>)
          .map((e) => IntervalSample.fromJson(e as Map<String, dynamic>))
          .toList(),
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
    );

GroupedScalarTimeseriesResponse _$GroupedScalarTimeseriesResponseFromJson(
        Map<String, dynamic> json) =>
    GroupedScalarTimeseriesResponse(
      groups: (json['groups'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) =>
                    GroupedScalarTimeseries.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      nextCursor: json['next_cursor'] as String?,
    );

GroupedIntervalTimeseriesResponse _$GroupedIntervalTimeseriesResponseFromJson(
        Map<String, dynamic> json) =>
    GroupedIntervalTimeseriesResponse(
      groups: (json['groups'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => GroupedIntervalTimeseries.fromJson(
                    e as Map<String, dynamic>))
                .toList()),
      ),
      nextCursor: json['next_cursor'] as String?,
    );

GroupedBloodPressureTimeseriesResponse
    _$GroupedBloodPressureTimeseriesResponseFromJson(
            Map<String, dynamic> json) =>
        GroupedBloodPressureTimeseriesResponse(
          groups: (json['groups'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) => GroupedBloodPressureTimeseries.fromJson(
                        e as Map<String, dynamic>))
                    .toList()),
          ),
          nextCursor: json['next_cursor'] as String?,
        );

const _$ScalarTimeseriesResourceEnumMap = {
  ScalarTimeseriesResource.bloodOxygen: 'blood_oxygen',
  ScalarTimeseriesResource.glucose: 'glucose',
  ScalarTimeseriesResource.heartrate: 'heartrate',
  ScalarTimeseriesResource.heartrateVariability: 'heartrate_variability',
  ScalarTimeseriesResource.respiratoryRate: 'respiratory_rate',
};

const _$IntervalTimeseriesResourceEnumMap = {
  IntervalTimeseriesResource.hypnogram: 'hypnogram',
  IntervalTimeseriesResource.steps: 'steps',
};
