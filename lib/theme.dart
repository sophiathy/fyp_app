import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';

ThemeData lightTheme(BuildContext context){
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    fontFamily: "Noto_Sans_JP",
    textTheme: TextTheme(
      //login page: app name title
      headline3: TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
        color: kTitleColor_light,
      ),
      bodyText2: TextStyle(color: kTitleColor_light),
    ),

    backgroundColor: kBackground_light,

    indicatorColor: kSectionBackground_light,

    inputDecorationTheme: inputDecorationTheme(),
    buttonColor: kInputBoxColor,
  );
}

ThemeData darkTheme(BuildContext context){
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    fontFamily: "Noto_Sans_JP",
    textTheme: TextTheme(
      //login page: app name title
      headline3: TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
        color: kTitleColor_dark,
      ),
      bodyText2: TextStyle(color: kTitleColor_dark),
    ),

    backgroundColor: kBackground_dark,

    indicatorColor: kSectionBackground_dark,

    inputDecorationTheme: inputDecorationTheme(),
    buttonColor: kIconBg_dark,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: kInputBoxColor),
    gapPadding: 10,
  );
  
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}
