import 'package:awesome_notification/utils/utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createPlantFoodNotification() async {
  String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title:
        'Buy Plant Food!!!',
        body: 'Florist at 123 Main St. has 2 in stock',
        bigPicture: 'asset://assets/notification_map.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
      schedule: NotificationInterval(
          interval: 60,
          // allowWhileIdle: true,
          timeZone: timezom,
          repeats: true)
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}