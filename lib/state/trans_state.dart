import 'dart:convert';

import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class WordState with ChangeNotifier{
  List<Word> words = [];

  getWord (Word word){
    print(word.arb.toString() + word.eng.toString());
    if(!words.contains(word)){
      words.add((word));
    }else{
      print(word.eng.toString() + word.arb.toString() + "is already in List");
    }
    notifyListeners();
  }
}//type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'