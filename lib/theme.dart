import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';

ThemeData theme(){
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: "Noto_Sans_JP",
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: kIndigoColor),
    gapPadding: 10,
  );
  
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
);
}

//**********maybe no use*****************
TextTheme textTheme(){
  return TextTheme(
    bodyText1: TextStyle(color: kTextColor_light),
    bodyText2: TextStyle(color: kTextColor_light),
  );
}