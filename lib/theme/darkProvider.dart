import 'package:flutter/material.dart';
import 'package:fyp_app/theme/darkPref.dart';

class DarkProvider with ChangeNotifier{
  //default: light mode
  bool _themeData = false;

  //an instance of DarkPref
  DarkPref dPref = DarkPref();
  
  //get the current theme data
  bool get themeData => _themeData;

  set themeData(bool theme){
    _themeData = theme;
    
    //set current theme to preference
    dPref.setDark(theme);
    notifyListeners();
  }
}
