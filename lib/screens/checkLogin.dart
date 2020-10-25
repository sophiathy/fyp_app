import 'package:flutter/material.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/screens/account/login.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:provider/provider.dart';

class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProperties>(context);

    print(user);
    //return Login page or Home screen
    if(user == null)
      return Login();
    else
      return Home();
  }
}