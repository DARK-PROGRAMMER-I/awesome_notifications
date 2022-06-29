import 'dart:convert';

import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class WordState with ChangeNotifier{
  List<Word> words = [];

  getWord (Word word){
    print(word.arb.toString() + word.eng.toString());
    words.add((word));
    notifyListeners();
  }
}//type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'