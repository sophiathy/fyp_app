import 'package:flutter/material.dart';
import 'package:fyp_app/theme/constants.dart';

ThemeData lightTheme(BuildContext context){
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    fontFamily: "Noto_Sans_JP",
    textTheme: TextTheme(
      //login: app name title
      headline3: TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
        color: kPrimaryColor_light,
      ),
      //register: title
      headline5: TextStyle(
        fontWeight: FontWeight.w700,
        color: kPrimaryColor_light,
      ),
      //section card title
      headline6: TextStyle(
        fontWeight: FontWeight.w700,
        color: kPrimaryColor_light,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.w300,
        color: kPrimaryColor_light,
      ),
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
      headline3: TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
        color: kPrimaryColor_dark,
      ),
      headline5: TextStyle(
        fontWeight: FontWeight.w700,
        color: kPrimaryColor_dark,
      ),
      headline6: TextStyle(
        fontWeight: FontWeight.w700,
        color: kPrimaryColor_dark,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.w300,
        color: kPrimaryColor_dark,
      ),
    ),

    backgroundColor: kBackground_dark,
    primaryColor: kPrimaryColor_dark,

    indicatorColor: kSectionBackground_dark,

    inputDecorationTheme: inputDecorationTheme(),
    buttonColor: kIconBg_dark,
  );
}

//used in Login
InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: kPrimaryColor_light),
    gapPadding: 10,
  );

  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 45, vertical: 25),
    border: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    errorBorder: outlineInputBorder,
    focusedErrorBorder: outlineInputBorder,
    errorStyle: TextStyle(
      height: 0,
      color: kPrimaryColor_light,
    ),
  );
}
