import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/workoutSummary.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/screens/account/login.dart';
import 'package:fyp_app/screens/account/register.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/screens/checkLogin.dart';
import 'package:fyp_app/screens/workingOut.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/theme/theme.dart';
import 'package:page_transition/page_transition.dart';
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
            initialRoute: '/checkLogin',
            onGenerateRoute: (page) {
              switch (page.name) {
                case '/checkLogin':
                  return PageTransition(child: CheckLogin(), type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/login':
                  return PageTransition(child: Login(), type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/register':
                  return PageTransition(child: Register(), type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/home':
                  return PageTransition(child: Home(), type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/workingOut':
                  return PageTransition(child: WorkingOut(workoutType: page.arguments), type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/workoutSummary':
                  return PageTransition(child: WorkoutSummary(workoutType: page.arguments), type: PageTransitionType.rightToLeftWithFade);
                  break;
                default:
                  return null;
              }
            },
            //FIXME:route
            // routes: {
            //   "/checkLogin": (context) => CheckLogin(),
            //   "/login": (context) => Login(),
            //   "/register": (context) => Register(),
            //   "/home": (context) => Home(),
            // },
          ),
        );
      }),
    );
  }
}

