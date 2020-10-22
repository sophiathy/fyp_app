import 'package:fyp_app/constants.dart';

dynamic modeChanger(bool modeSwitch){
  if(modeSwitch)
    return kSectionBackground_dark;
  else
    return kSectionBackground_light;
}

/* class ThemeChanger with ChangeNotifier{
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme){
    _themeData = theme;

    notifyListeners();
  }
} */