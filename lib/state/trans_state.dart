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


  getWord (Word word){
    if(engWords.isNotEmpty){
      if(!engWords.contains(word.eng)){
        print(word);
        engWords.add(word.eng);
        arbWords.add(word.arb);
        dates.add(word.date);
        notifyListeners();
        // here im getting error
      }
    }else{
      engWords.add(word.eng);
      arbWords.add(word.arb);
      dates.add(word.date);
      notifyListeners();
    }

// Continue from here
  }
}