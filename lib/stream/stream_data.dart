import 'dart:convert';
import 'dart:async';
import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class StreamUser {
  StreamController<Word> _streamController = StreamController();
  Future<void> getWord(String imei) async{

    var url = Uri.parse('https://ihfath.herokuapp.com/api/v1/Getword/${imei}');

    final response = await http.get(url);


    try{
      if(response.statusCode  == 200){
        final databody = json.decode(response.body)['Word'].first;
        print('Success');
        // print(databody);
        // var data = jsonDecode(response.body)['Word'] as List;
        Word dataModel = new Word.fromJson(databody);
        // data.forEach((element) {
        //   print(element);
        //   words.add(element);
        // });
        // add API response to stream controller sink
        // print(dataModel);
        _streamController.sink.add(dataModel);

      }


    }catch(e){
      print(e);
      print('fatal Error');

    }


  }
}
