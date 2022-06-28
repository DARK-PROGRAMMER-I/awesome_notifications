import 'dart:io';

import 'package:awesome_notification/screens/navigaton_page.dart';
import 'package:awesome_notification/state/trans_state.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notification Created on ${notification.channelKey}',
        ),
      ));
    });

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
              AwesomeNotifications().setGlobalBadgeCounter(value - 1),
        );
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => NavigationPage(),
        ),
            (route) => route.isFirst,
      );
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordState>(context).fetch_data(4);
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                createPlantFoodNotification;
              }, child: Text('Start Notifications'))
              ,ElevatedButton(onPressed:(){
                // Function for canceling all notifications
                cancelScheduledNotifications;
              }, child: Text('Cancel Notifications'))
            ],
          ),
        ),
      ),
    );
  }
}
