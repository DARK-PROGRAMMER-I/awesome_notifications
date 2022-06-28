import 'package:awesome_notification/utils/utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createPlantFoodNotification() async {
  String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Title Here', // ${items.call().first}
        body: 'Florist at 123 Main St. has 2 in stock',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationInterval(
          interval: 61,
          timeZone: timezom,
          repeats: true)
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}