import 'package:flutter/material.dart';

import './constants.dart';

ThemeData basicTheme() => ThemeData(
  brightness: Brightness.dark,
  primaryColor: kPrimaryColor,
  backgroundColor: kBackgroundColor,

  textTheme: TextTheme(
    headline6: TextStyle(
      fontFamily: FontNameTitle,
      fontSize: MediumTextSize,
      color: Colors.purple,
    ),
    headline4: TextStyle(
      fontFamily: FontNameDefault,
      fontSize: MediumTextSize,
      fontWeight: FontWeight.w800,
      color: kSecondaryColor,
    ),
    bodyText1: TextStyle(
      fontFamily: FontNameDefault,
      fontSize: BodyTextSize,
      color: Colors.green,
    ),
  ),

  iconTheme: IconThemeData(
    // color: Colors.red,
    size: 25.0,
    color: Colors.amber,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.red,
    foregroundColor: Colors.purple,
  ),

  accentColor: Colors.amber,
  buttonTheme: ButtonThemeData(
    height: 80,
    buttonColor: Colors.amber,
    textTheme: ButtonTextTheme.accent,
  ),

  bottomAppBarColor: Colors.red,
  // cardColor: Colors.orange.shade100,
  // scaffoldBackgroundColor: Color(0xff203152),
);
