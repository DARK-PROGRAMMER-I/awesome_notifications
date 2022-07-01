import 'dart:async';
import 'dart:io';
import 'package:awesome_notification/model/translation.dart';
import 'package:awesome_notification/screens/navigaton_page.dart';
import 'package:awesome_notification/screens/notifications.dart';
import 'package:awesome_notification/state/trans_state.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  StreamController<Word> streamController = StreamController.broadcast();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notifications initialized...')),
      );
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


    getWord('ahmad');
    Timer.periodic(Duration(seconds: 900), (timer) {
      getWord('ahmad');
    });


  }


  Future<void> getWord(String imei) async{
    var url = Uri.parse('https://ihfath.herokuapp.com/api/v1/Getword/${imei}');
    final response = await http.get(url);
    try{
      if(response.statusCode  == 200){
        final databody = json.decode(response.body)['Word'];
        print('Success');
        databody.forEach((element){
          getStreamWord(Word.fromJson(element));
        });
      }
    }catch(e){
      print(e);
      print('fatal Error');
    }

  }
  getStreamWord(Word word)async{
    Provider.of<WordState>(context, listen: false).getWord(word);
    print('GET STREAM WORD');
    streamController.sink.add(word);

  }


  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    // stop streaming when app close
    // _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final engProv = Provider.of<WordState>(context).engWords;
    final arbProv = Provider.of<WordState>(context).arbWords;
    final provider = Provider.of<WordState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
        leading: IconButton(
            onPressed: () async {
              createWordNotification(engProv.last.toString(), arbProv.last.toString());
            },
            icon: Icon(Icons.notifications_active_rounded)),
        actions: [
          IconButton(onPressed: ()async{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cancelled all notifications...'))
            );
            cancelScheduledNotifications();
          }, icon: Icon(Icons.notifications_off)),
        ],
      ),
      body:  StreamBuilder(
          stream: streamController.stream,
          builder: (context, snap){
             if(snap.hasData){
                 return listTile(snap.data,context);
               }
             if(snap.hasError){
                 print('ERROR SNAP');
                 return CircularProgressIndicator();
              }else{
               return Center(child: CircularProgressIndicator());
             }

            }


      ));
  }
}

Widget listTile(var word, BuildContext context){

  final engProvider = Provider.of<WordState>(context).engWords;
  final arbProvider = Provider.of<WordState>(context).arbWords;
  final dateProvider = Provider.of<WordState>(context).dates;

  return engProvider.length == 0 || engProvider.length == null ? Center(child: CircularProgressIndicator(),):
  ListView.builder(
      itemCount: engProvider.length,
      itemBuilder: (context, index){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(dateProvider[index], style: TextStyle(fontSize: 15),)),
            ListTile(
              // title: Text(dateProvider[index].toString()),
              leading: Text(engProvider[index].toString(), style: TextStyle(fontSize: 20),),
              trailing: Text(arbProvider[index].toString(), style: TextStyle(fontSize: 20),),
            ),
          ],
        ),
      );
  });
}

