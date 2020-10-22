import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/screens/account_auth/loginForm.dart';
import 'package:fyp_app/services/authAccount.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //TODO:
  //final AuthService _auth = AuthService();  //instance of AuthService
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: SafeArea(
                  top: true,
                  left: true,
                  right: true,
                  child: Text(
                    "Exercise\nTracker",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                      .textTheme
                      .headline3
                  ),
                ),
              ),

              //login form
              LoginForm(),
            ],
          ),
        ),
      ),
      //TODO:
      /*dynamic result = await _auth.signInAnon();  //return null or a user
      if(result == null)
        print("Error while sigining in !");
      else{
        print("Signed in with: ");
        print(result);
      }*/
    );
  }
}