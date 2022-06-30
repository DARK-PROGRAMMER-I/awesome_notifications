import 'dart:async';
import 'dart:convert';

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

  getNotified(String eng, String arb){
    createWordNotification(eng, arb);

  }

  getWord (Word word){
    if(engWords.isNotEmpty){
      if(!engWords.contains(word.eng)){
        engWords.add(word.eng);
        arbWords.add(word.arb);
        dates.add(word.date);
        getNotified(engWords[engWords.length -1 ].toString(), arbWords[arbWords.length -1].toString());
      }
    }else{
      engWords.add(word.eng);
      arbWords.add(word.arb);
      dates.add(word.date);
    }

  }
}