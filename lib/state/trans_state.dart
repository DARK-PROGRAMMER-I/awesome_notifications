import 'dart:async';
import 'dart:convert';

import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class WordState with ChangeNotifier{
  StreamController<Word> streamController = StreamController();
  List<Word> words = [];

  getWord (Word word){
    if(words.isNotEmpty){
      for(int i = 0; i<= words.length; i++ ){
        print(words[i] == word);
        print('Outer Loop');
        if(words[i] != word){
          print('Inner Loop');
          words.add(word);
          streamController.sink.add(word);
        }
      }
      print(word);
    }

    print(words.length);

  }
}//type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'