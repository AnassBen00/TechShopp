import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/Location/Location.dart';
import 'package:shopping_app/provider/app_provider.dart';

Color deepOrange = Colors.deepOrange;
Color black = Colors.black;
Color white = Colors.white;
Color grey = Colors.grey;
String cat;
String L;

// methods
void changeScreen(BuildContext context, Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void changeScreenReplacement(BuildContext context, Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
}

