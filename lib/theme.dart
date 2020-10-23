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
        color: kPrimaryColor_light,
      ),
      bodyText2: TextStyle(color: kPrimaryColor_light),
    ),

    backgroundColor: kBackground_light,
    primaryColor: kPrimaryColor_light,

    indicatorColor: kSectionBackground_light,

    inputDecorationTheme: inputDecorationTheme(),
    buttonColor: kPrimaryColor_light,
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
        color: kPrimaryColor_dark,
      ),
      bodyText2: TextStyle(color: kPrimaryColor_dark),
    ),

    backgroundColor: kBackground_dark,
    primaryColor: kPrimaryColor_dark,

    indicatorColor: kSectionBackground_dark,

    inputDecorationTheme: inputDecorationTheme(),
    buttonColor: kIconBg_dark,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: kPrimaryColor_light),
    gapPadding: 10,
  );
  
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 25),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}
