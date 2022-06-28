import 'dart:convert';

import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class WordState with ChangeNotifier{
  List words = [];
  Future<List<Word>?> fetch_data(int imei)async{
    String url = 'https://ihfath.herokuapp.com/api/v1/Getword/${imei}';
    try{
      // Get response from Api
      http.Response response = await http.get(Uri.parse(url));
      // Check Status code
      if(response.statusCode  == 200){
          print('Success');
          var data = jsonDecode(response.body)['Word'] as List;

        Iterable list = data;
          var listMap  = list.map((word) => Word.fromJson(word)).toList();
          words = listMap;
          print(words);
          return listMap;
      }

    }catch(e){
      print(e);
      print('fatal Error');
      return [];
    }
  }
}