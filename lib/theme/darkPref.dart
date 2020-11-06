import 'package:shared_preferences/shared_preferences.dart';

class DarkPref{
  static const CurrentTheme = "CurrentTheme";

  Future <bool> getDark() async{
    //parse the shared preferences
    SharedPreferences p = await SharedPreferences.getInstance();
    
    //get and return the boolean for the theme preference
    //if the boolean is non-null then returns its value, otherwise return false by default
    return p.getBool(CurrentTheme) ?? false;
  }

  setDark(bool theme) async{
    //parse the shared preferences
    SharedPreferences p = await SharedPreferences.getInstance();
    
    //set the boolean for the theme preference
    p.setBool(CurrentTheme, theme);
  }
}