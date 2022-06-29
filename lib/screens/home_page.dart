import 'dart:async';
import 'dart:io';
import 'package:awesome_notification/model/translation.dart';
import 'package:awesome_notification/screens/navigaton_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  StreamController<Word> _streamController = StreamController();


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
    Timer.periodic(Duration(seconds: 3), (timer) {
      streamUser.getWord('hola');
    });

  }
  Future<void> getWord(String imei) async{

    var url = Uri.parse('https://ihfath.herokuapp.com/api/v1/Getword/${imei}');

    final response = await http.get(url);


    try{
      if(response.statusCode  == 200){
        final databody = json.decode(response.body)['Word'].first;
        print('Success');
        // print(databody);
        // var data = jsonDecode(response.body)['Word'] as List;
        Word dataModel = new Word.fromJson(databody);
        // data.forEach((element) {
        //   print(element);
        //   words.add(element);
        // });
        // add API response to stream controller sink
        // print(dataModel);
        _streamController.sink.add(dataModel);

      }


    }catch(e){
      print(e);
      print('fatal Error');

    }


  }



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
  print(word);
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