import 'dart:async';
import 'package:awesome_notification/model/translation.dart';
import 'package:awesome_notification/screens/notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class WordState with ChangeNotifier{
  StreamController<Word> streamController = StreamController();
  List<Word> words = [];
  List engWords = [];
  List arbWords = [];
  List dates = [];

  getNotified(){
    String eng = engWords[engWords.length -1].toString();
    String arb = arbWords[arbWords.length -1].toString();
    // createBasicNotification(eng, arb);
    return [eng,arb];

  }

  check_lists(){
    List words= getNotified();
    print(words);
    // createWordNotification(words[0], words[words.length-1]);
  }
  //
  // void getLastElement(){
  //   String eng = engWords[engWords.length -1].toString();
  //   String arb = arbWords[arbWords.length -1].toString();
  //   print(eng);
  //   print(arb);
  //   getNotified(eng, arb);
  // }

  getWord (Word word){
    if(engWords.isNotEmpty){
      if(!engWords.contains(word.eng)){
        print(word);
        engWords.add(word.eng);
        arbWords.add(word.arb);
        createWordNotification(word.eng.toString(), word.arb.toString());
        dates.add(word.date);
        // here im getting error
      }
    }else{
      engWords.add(word.eng);
      arbWords.add(word.arb);
      dates.add(word.date);
      createWordNotification(word.eng.toString(), word.arb.toString());
    }

// Continue from here
  }
}