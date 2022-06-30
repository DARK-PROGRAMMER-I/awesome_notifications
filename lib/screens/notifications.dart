import 'package:awesome_notification/state/trans_state.dart';
import 'package:awesome_notification/utils/utils.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


Future<void> createWordNotification(String eng,String arb) async {

  print(eng + '  '+ arb);
  String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'scheduled_channel',
        title: '$eng',
        body: '$arb' ,
      ),
      // actionButtons: [
      //   NotificationActionButton(
      //     key: 'MARK_DONE',
      //     label: 'Mark Done',
      //   ),
      // ],
      schedule: NotificationInterval(
          interval: 60,
          timeZone: timezom,
          repeats: true)
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}