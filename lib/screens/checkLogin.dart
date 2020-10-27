import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:provider/provider.dart';

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      final user = Provider.of<UserProperties>(context, listen: false);
      navigate(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Center(
          child: Text(
            "Exercise\nTracker",
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

  void navigate(final user) async{
    print(user);
    //return Login page or Home screen
    if(user == null)
      Navigator.of(context).pushReplacementNamed('/login');
    else
      Navigator.of(context).pushReplacementNamed('/home');
  }
}
