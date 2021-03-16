import 'package:flutter/material.dart';

const kBackground_light = Color(0xFFE1F5FE);
const kBackground_dark = Colors.black87;

const kPrimaryColor_light = Colors.indigo;
const kPrimaryColor_dark = Colors.white;

//Sections at Home
const kSectionBackground_light = Colors.white;
const kSectionBackground_dark = Color(0xFF212121);

//used in Today's Summary
const kIconBg_light = Color(0xFFECEFF1);
const kIconBg_dark = Color(0xFF424242); //kBorder_dark

const kBorder_light = Colors.lightBlueAccent;
const kOkOrStart = Color(0xFF00CA71);
const kStopOrAutoBtn = Colors.redAccent;
const kReturn = Colors.indigoAccent;
const kDisabled = Color(0xFF90A4AE);

//used in pie chart (auto tracking mode)
const kWalking = Colors.indigo;
const kUpstairs = Colors.red;
const kDownstairs = Colors.green;
const kRunning = Colors.orange;
const kCycling = Colors.purple;
const kStanding = Colors.teal;
const kSitting = Colors.yellow;

//regular expression
final RegExp emailRegExp =
    RegExp(r"^[A-Za-z0-9.!#$%&’*+/=?^_`{|}~-]+@[A-Za-z0-9]+\.[A-Za-z]+");

//error messages used in login
const String kEmailNull = "Please enter your email.";
const String kPasswordNull = "Please enter your password.";

const String kInvalidEmail = "Invalid email. Please enter again.";
const String kInvalidPassword = "Invalid password. Please enter again.";

const String kAccountNotFound = "Invalid email or wrong password.";

const String kAnonymousLoginError = "Error while logging in...";

//error messages used in register
const String kAccountExists = "The account has been registered.";
const String kShortPassword = "Password is too short. (at least 6 chars)";
const String kNotMatchPassword = "Password is not match. Please enter again.";
const String kConfirmPasswordNull = "Please enter your confirm password.";

/* //not in used
const kActiveIconColor = Color(0xFFE68342);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6); */
