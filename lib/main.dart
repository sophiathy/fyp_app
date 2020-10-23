import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/darkProvider.dart';
import 'package:fyp_app/screens/account_auth/login.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/checkLogin.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/theme.dart';
import 'package:provider/provider.dart';

//TODO:Solvig No Firebase App 'DEFAULT' has been created
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State <MyApp> {
  DarkProvider modeProvider = new DarkProvider();
  
  //get the current theme from the Preferences
  //set value back to the Provider
  void getCurrentTheme() async{
    modeProvider.themeData = await modeProvider.dPref.getDark();
  }
  
  @override
  void initState(){
    super.initState();
    getCurrentTheme();
  }

  @override
  Widget build(BuildContext context) {
    //TODO:need comment
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkProvider>(
          create: (context){
            return modeProvider;
          },
        ),
      ],
      //TODO: important! this fixes all the problems of dark mode
      child: Consumer<DarkProvider>(
        builder: (BuildContext context, value, Widget child){
        return StreamProvider<UserProperties>.value(
          value: AuthService().user,    //accessing the user stream
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme(context),
            darkTheme: darkTheme(context),
            themeMode: modeProvider.themeData ? ThemeMode.dark : ThemeMode.light,
            home: CheckLogin(),
            routes: {
              "checkLogin": (context) => CheckLogin(),
              "login": (context) => Login(),
              "home": (context) => Home(),
            },
          ),
        );
      }),
    );
  }
}

