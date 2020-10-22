import 'package:flutter/material.dart';
import 'package:fyp_app/widgets/buttons.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState()
  ;
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey <FormState>();
  final List <String> errors = [];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          //email field
          TextFormField(
            //keyboard for typing email address
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              //floatingLabel must be added here, it won't work in theme.dart
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (data){
              if(data.isEmpty){
                setState(() {
                  errors.add("Please enter your email.");
                });
              }
              return null;
            },
          ),

          SizedBox(height: 25),

          //password field
          TextFormField(
            //hide password
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              //floatingLabel must be added here, it won't work in theme.dart
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),

          SizedBox(height: 25),

          //login button
          Buttons(
            name: "Login",
            press: (){},
          ),
        ],
      ),
    );
  }
}

