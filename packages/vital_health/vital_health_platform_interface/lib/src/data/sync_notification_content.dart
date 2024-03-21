class SyncNotificationContent {
  final String notificationTitle;
  final String notificationContent;
  final String channelName;
  final String channelDescription;

  SyncNotificationContent(this.notificationTitle, this.notificationContent,
      this.channelName, this.channelDescription);

  Map<String, String> toMap() {
    return {
      "notificationTitle": this.notificationTitle,
      "notificationContent": this.notificationContent,
      "channelName": this.channelName,
      "channelDescription": this.channelDescription,
    };
  }
}
