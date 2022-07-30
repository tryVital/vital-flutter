import 'package:vital_flutter/vital_resource.dart';

enum SyncStatusType {
  failedSyncing,
  successSyncing,
  nothingToSync,
  syncing,
  syncingCompleted,
  unknown,
}

abstract class SyncStatus {
  final SyncStatusType status;

  SyncStatus(this.status);
}

class SyncStatusFailed extends SyncStatus {
  final VitalResource resource;
  final String? error;

  SyncStatusFailed(this.resource, this.error) : super(SyncStatusType.failedSyncing);
}

class SyncStatusSuccessSyncing extends SyncStatus {
  final VitalResource resource;

  SyncStatusSuccessSyncing(this.resource, PostResourceData data) : super(SyncStatusType.syncingCompleted);
}

class SyncStatusNothingToSync extends SyncStatus {
  final VitalResource resource;

  SyncStatusNothingToSync(this.resource) : super(SyncStatusType.nothingToSync);
}

class SyncStatusSyncing extends SyncStatus {
  final VitalResource resource;

  SyncStatusSyncing(this.resource) : super(SyncStatusType.syncing);
}

class SyncStatusCompleted extends SyncStatus {
  SyncStatusCompleted() : super(SyncStatusType.syncingCompleted);
}

class SyncStatusUnknown extends SyncStatus {
  SyncStatusUnknown() : super(SyncStatusType.unknown);
}

SyncStatus mapArgumentsToStatus(List<dynamic> arguments) {
  switch (arguments[0] as String) {
    case 'failedSyncing':
      return SyncStatusFailed(VitalResource.values.firstWhere((it) => it.name == arguments[1]), arguments[2]);
    case 'successSyncing':
      return SyncStatusSuccessSyncing(
        VitalResource.values.firstWhere((it) => it.name == arguments[1]),
        PostResourceData.fromArgument(arguments[2]),
      );
    case 'nothingToSync':
      return SyncStatusNothingToSync(VitalResource.values.firstWhere((it) => it.name == arguments[1]));
    case 'syncing':
      return SyncStatusSyncing(VitalResource.values.firstWhere((it) => it.name == arguments[1]));
    case 'syncingCompleted':
      return SyncStatusCompleted();
    default:
      return SyncStatusUnknown();
  }
}

enum PostResourceDataType { summary, timeSeries, unknown }

class PostResourceData {
  final PostResourceDataType type;

  PostResourceData(this.type);

  factory PostResourceData.fromArgument(List<dynamic> argument) {
    switch (argument[0]) {
      case "summary":
        return PostResourceSummaryData._init(argument[1]);
      case "timeSeries":
        return PostResourceTimeSeriesData._init(argument[1]);
      default:
        return PostResourceData(PostResourceDataType.unknown);
    }
  }
}

class PostResourceSummaryData extends PostResourceData {
  final dynamic summary;

  PostResourceSummaryData._init(this.summary) : super(PostResourceDataType.summary);
}

class PostResourceTimeSeriesData extends PostResourceData {
  final dynamic timeSeries;

  PostResourceTimeSeriesData._init(this.timeSeries) : super(PostResourceDataType.timeSeries);
}
