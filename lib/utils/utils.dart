import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<String> items(){
  var  itemList = ['1','2','3','4','5','6','7', ];
  var word= Future.delayed(Duration(seconds: 60), () {
    itemList.removeAt(0);
    return itemList.first;
  });
  return word;
}

