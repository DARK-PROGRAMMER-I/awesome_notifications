import 'dart:async';
import 'dart:convert';

import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class WordState with ChangeNotifier{
  StreamController<Word> streamController = StreamController();
  List<Word> words = [];

  getWord (Word word){
    print('Inside Trans State Function');
    print(word);
    if(words.isNotEmpty){
      for(int i = 0; i<= words.length; i++ ){
        print(words[i] == word);
        print('Outer Loop');
        if(words[i] != word){
          print('Inner Loop');
          words.add(word);
        }
      }
      print(word);
    }else{
      print('inside else statement');
      words.add(word);
    }

    print(words.length);

  }
}//type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'