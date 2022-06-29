import 'dart:async';
import 'dart:io';

import 'package:awesome_notification/model/translation.dart';
import 'package:awesome_notification/screens/navigaton_page.dart';
import 'package:awesome_notification/state/trans_state.dart';
import 'package:awesome_notification/stream/stream_data.dart';
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

  StreamUser streamUser= StreamUser();


  void initState() {
    super.initState();
    streamUser.getWord('hola');
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
  StreamController<Word> _streamController = StreamController();

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    // stop streaming when app close
    _streamController.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // final provider1 = Provider.of<WordState>(context).fetch_data(4);
    // final provider2 = Provider.of<WordState>(context);
    // print(provider2.words);
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder<Word>(
            stream: _streamController.stream,
            builder:(context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
                default: if(snapshot.hasError){
                  return Text('Please Wait....');
                }else{
                  return listTile(snapshot.data!);
                }
              }
            },

          ),
        ),
      ),
    );
  }
}

Widget listTile(Word word){
  return ListView(
    children: [
      Center(child: Text(word.eng.toString()),)
    ],
  );
}


//Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(onPressed: (){
//                   createPlantFoodNotification;
//                 }, child: Text('Start Notifications'))
//                 ,ElevatedButton(onPressed:(){
//                   // Function for canceling all notifications
//                   cancelScheduledNotifications;
//                 }, child: Text('Cancel Notifications'))
//               ],
//             ),