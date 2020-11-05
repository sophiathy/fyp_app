import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/darkProvider.dart';
import 'package:provider/provider.dart';

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      navigate();
    });
  }

  @override
  Widget build(BuildContext context) {
    DarkProvider modeSwitch = Provider.of<DarkProvider>(context);
    return Scaffold(
      backgroundColor: modeSwitch.themeData ? kBackground_dark : kPrimaryColor_light,
      body: Container(
        child: Center(
          child: Text(
            "Exercise\nTracker",          //splash screen
            style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(
                color: Colors.white,
              ),
          ),
        ),
      ),
    );
  }

  void navigate() async{
    FirebaseAuth.instance.authStateChanges().listen((User u){
      print(u);
      //return Login page or Home screen
      if(u == null)
        Navigator.of(context).pushReplacementNamed('/login');
      else
        Navigator.of(context).pushReplacementNamed('/home');
    });
  }
}
