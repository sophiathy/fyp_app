import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<User> _firebaseAuthSubs;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration(seconds: 3), () {
        navigate();
      });
    }
  }

  @override
  void dispose() {
    _firebaseAuthSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DarkProvider modeSwitch = Provider.of<DarkProvider>(context);
    AdaptiveSize().init(context); //initialize screen data
    return Scaffold(
      backgroundColor:
          modeSwitch.themeData ? Colors.black : kPrimaryColor_light,
      body: Container(
        child: Center(
          child: TextLiquidFill(
            text: "Exercise Tracker",
            waveDuration: Duration(milliseconds: 1000),
            loadDuration: Duration(milliseconds: 2000),
            waveColor: Colors.white,
            boxBackgroundColor:
                modeSwitch.themeData ? Colors.black : kPrimaryColor_light,
            textStyle: TextStyle(
              fontSize: getProportionWidth(38.0),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
          // child: Text(
          //   "Exercise\nTracker",          //splash screen
          //   style: Theme.of(context)
          //     .textTheme
          //     .headline3
          //     .copyWith(
          //       color: Colors.white,
          //     ),
          // ),
        ),
      ),
    );
  }

  void navigate() async {
    _firebaseAuthSubs =
        FirebaseAuth.instance.authStateChanges().listen((User u) {
      print(u);
      //return Login page or Home screen
      if (u == null)
        Navigator.of(context).pushReplacementNamed('/login');
      else
        Navigator.of(context).pushReplacementNamed('/home');
    });
  }
}
