import 'package:awesome_notification/model/translation.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {

  NavigationPage({Key? key,}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome'),
      ),

    );
  }
}
