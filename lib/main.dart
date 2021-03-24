import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/screens/about.dart';
import 'package:fyp_app/screens/reviewRecord.dart';
import 'package:fyp_app/screens/splashScreen.dart';
import 'package:fyp_app/screens/userManual.dart';
import 'package:fyp_app/screens/workoutSummary.dart';
import 'package:fyp_app/services/screenArguments.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/screens/login.dart';
import 'package:fyp_app/screens/register.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/screens/workingOut.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/theme/theme.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//*********************Designed by Tang Ho Yan Sophia (sophiathy2@gmail.com)***********************//

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDirectory = await getApplicationDocumentsDirectory();
  await Firebase.initializeApp();
  await Hive.initFlutter(appDirectory.path); //path of hive stored

  await Hive.openBox<int>(
      'settings'); //store tracking mode(key 0), lastSavedRecordIndex(key 10), unlock "Auto" requirements(key 20-24)

  await Hive.openBox<int>('steps'); //store last saved today's steps counted
  await Hive.openBox<int>(
      'todaysDuration'); //store last saved today's workout seconds
  await Hive.openBox<double>(
      'todaysDistance'); //store last saved today's workout distance
  await Hive.openBox<List<dynamic>>(
      'recentRecords'); //store 5 recently saved records

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkProvider modeProvider = new DarkProvider();

  //get the current theme from the Preferences
  //set value back to the Provider
  void getCurrentTheme() async {
    modeProvider.themeData = await modeProvider.dPref.getDark();
  }

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  @override
  Widget build(BuildContext context) {
    //listen to the change of theme
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DarkProvider>(
          create: (context) {
            return modeProvider;
          },
        ),
      ],
      child: Consumer<DarkProvider>(
          builder: (BuildContext context, value, Widget child) {
        return StreamProvider<UserProperties>.value(
          initialData: null,
          value: AuthAccount().user, //accessing the user stream
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme(context),
            darkTheme: darkTheme(context),
            themeMode:
                modeProvider.themeData ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/splash',
            onGenerateRoute: (page) {
              ScreenArguments args = page.arguments;
              switch (page.name) {
                case '/splash':
                  return PageTransition(
                      child: SplashScreen(),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/login':
                  return PageTransition(
                      child: Login(),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/register':
                  return PageTransition(
                      child: Register(),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/userManual':
                  return PageTransition(
                      child: UserManual(),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/about':
                  return PageTransition(
                      child: About(),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/home':
                  return PageTransition(
                      child: Home(),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/workingOut':
                  return PageTransition(
                      child: WorkingOut(
                          workoutType: args.workoutType,
                          countActivities: args.countActivities,
                          route: args.route,
                          duration: args.duration,
                          totalDistance: args.totalDistance,
                          csvRows: args.csvRows,
                          todaySteps: args.todaySteps,
                          averageSpeed: args.averageSpeed,
                          highestSpeed: args.highestSpeed),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/workoutSummary':
                  return PageTransition(
                      child: WorkoutSummary(
                          workoutType: args.workoutType,
                          countActivities: args.countActivities,
                          route: args.route,
                          duration: args.duration,
                          totalDistance: args.totalDistance,
                          csvRows: args.csvRows,
                          todaySteps: args.todaySteps,
                          averageSpeed: args.averageSpeed,
                          highestSpeed: args.highestSpeed),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                case '/reviewRecord':
                  return PageTransition(
                      child: ReviewRecord(
                          recordIndex: args.recordIndex,
                          workoutType: args.workoutType,
                          countActivities: args.countActivities,
                          route: args.route,
                          duration: args.duration,
                          totalDistance: args.totalDistance,
                          csvRows: args.csvRows,
                          todaySteps: args.todaySteps,
                          averageSpeed: args.averageSpeed,
                          highestSpeed: args.highestSpeed),
                      type: PageTransitionType.rightToLeftWithFade);
                  break;
                default:
                  return null;
              }
            },
          ),
        );
      }),
    );
  }
}
