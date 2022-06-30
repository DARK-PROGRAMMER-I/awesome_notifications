import 'dart:math';

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

      schedule: NotificationCalendar(
      repeats: false,
      timeZone: timezom,
      millisecond: 20
  )
  );
}

Future<void> createBasicNotification(String eng, String arb) async {
  String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title:
        '$eng',
        body: '$arb',
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