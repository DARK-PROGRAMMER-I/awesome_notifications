import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

List items(){
  var  itemList = ['1','2','3','4','5','6','7', ];
  return itemList;
}