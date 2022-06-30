import 'dart:async';
import 'dart:io';
import 'package:awesome_notification/model/translation.dart';
import 'package:awesome_notification/screens/navigaton_page.dart';
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
    getWord('1');
    Timer.periodic(Duration(seconds: 3), (timer) {
      getWord('1');
    });
  }
  Future<void> getWord(String imei) async{
    var url = Uri.parse('https://ihfath.herokuapp.com/api/v1/Getword/${imei}');
    final response = await http.get(url);
    Word? word;
    try{
      if(response.statusCode  == 200){
        final databody = json.decode(response.body)['Word'];
        print('Success');
        databody.forEach((element){
          word = Word.fromJson(element);
        });
        getStreamWord(word!);
        print('HERE WE ARWE');
      }
    }catch(e){
      print(e);
      print('fatal Error');
    }

  }
  getStreamWord(Word word)async{
    print(word.toString() + 'Error here');
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
    // final provider1 = Provider.of<WordState>(context).words;
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body:  StreamBuilder(
          stream: streamController.stream,
          builder: (context, snap){
             if(snap.hasData){
               print(snap.data);
               print('Has DATA');
                 return listTile(snap.data,context);
               }
             if(snap.hasError){
                 print('ERROR SNAP');
                 return CircularProgressIndicator();
              }else{
               return CircularProgressIndicator();
             }

            }


      ));
  }
}

Widget listTile(var word, BuildContext context){
  Provider.of<WordState>(context, listen: false).getWord(word);
  final provider1 = Provider.of<WordState>(context).words;
  print(provider1.length);
  return provider1.length == 0 || provider1.length == null ? Center(child: CircularProgressIndicator(),):
  ListView.builder(
      itemCount: provider1.length,
      itemBuilder: (context, index){
      return ListTile(
        leading: Text(provider1[index].eng.toString()),
        trailing: Text(provider1[index].arb.toString()),
      );
  });
}

