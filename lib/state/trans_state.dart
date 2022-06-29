import 'dart:convert';

import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class WordState with ChangeNotifier{
  List<Word> words = [];

  getWord (Word word){
    //
    // if(words.length > 0 && words.length != 0){
    //   words.forEach((element)  {
    //     element == word;
    //     words.add(word);
    //     notifyListeners();
    //   });
    // }else{
    //   words.add(word);
    //   print('Already present');
    // }

    print(word);
    words.add(word);
    print(words.length);
    // if(words.contains(word)){
    //   words.add(word);
    //   notifyListeners();
    // }else{
    //   print(word.eng.toString() + word.arb.toString() + "is already in List");
    // }
  }
}//type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'