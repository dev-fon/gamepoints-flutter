import 'package:flutter/material.dart';

class GpThemes {
  static final themes = [
    ThemeData(primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepOrangeAccent,
            brightness: Brightness.dark,
            primaryTextTheme:
                TextTheme(display1: TextStyle(color: Colors.white))),
    ThemeData(primarySwatch: Colors.blue,
            accentColor: Colors.blueAccent,
            brightness: Brightness.dark,
            primaryTextTheme:
                TextTheme(display1: TextStyle(color: Colors.white))),
    ThemeData(primarySwatch: Colors.green,
            accentColor: Colors.greenAccent,
            brightness: Brightness.dark,
            primaryTextTheme:
                TextTheme(display1: TextStyle(color: Colors.white))),
    ThemeData(primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepPurpleAccent,
            brightness: Brightness.dark,
            primaryTextTheme:
                TextTheme(display1: TextStyle(color: Colors.white)),
    ),
    ThemeData(primarySwatch: Colors.pink,
            accentColor: Colors.pinkAccent,
            brightness: Brightness.dark,
            primaryTextTheme:
                TextTheme(display1: TextStyle(color: Colors.white)),
    ),
    ThemeData(primarySwatch: Colors.grey,
            accentColor: Colors.blueGrey,
            brightness: Brightness.light,
            primaryTextTheme:
                TextTheme(display1: TextStyle(color: Colors.black)),
    ),
  ];
}