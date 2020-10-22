import 'package:flutter/material.dart';
import 'package:fyp_app/screens/account_auth/auth.dart';
import 'package:fyp_app/screens/home.dart';
import 'package:fyp_app/screens/account_auth/login.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return Authenticate or Home screen
    return Home();
  }
}