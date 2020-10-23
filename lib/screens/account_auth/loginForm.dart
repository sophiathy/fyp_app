import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/screens/account_auth/errorMessage.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/widgets/buttons.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState()
  ;
}

class _LoginFormState extends State<LoginForm> {
  final AuthService _auth = AuthService();
  
  final _formKey = GlobalKey <FormState>();
  final List <String> errors = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //email field
          TextFormField(
            //keyboard for typing email address
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              //prefixIcon color based on primaryColor
              prefixIcon: Icon(
                Icons.email_rounded,
              ),
              hintText: "Enter your email",
              //floatingLabel must be added here, it won't work in theme.dart
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (data){
              if(data.isEmpty && !errors.contains(kEmailNull)){
                setState(() {
                  errors.add(kEmailNull); //if the message is not inside the List "errors", then add
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
              prefixIcon: Icon(
                Icons.lock_rounded,
              ),
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            validator: (data){
              if(data.isEmpty && !errors.contains(kPasswordNull)){
                setState(() {
                  errors.add(kPasswordNull);
                });
              }
              return null;
            },
          ),

          SizedBox(height: 25),
          
          ErrorMessage(errors: errors),

          SizedBox(height: 15),

          //login button
          Buttons(
            name: "Login",
            press: (){
              if(_formKey.currentState.validate())
                _formKey.currentState.save();
            },
          ),

          SizedBox(height: 15),

          //TODO: Redesign button: login (anonymous)
          SizedBox(
            width: double.infinity,
            height: 50.0,
            child: FlatButton(
              color: Colors.indigo[300],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              onPressed: () async {
                dynamic getResult = await _auth.signInAnon(); //null or Firebase user

                if(getResult != null){
                  print("Logged In as");
                  print(getResult);
                }else
                  print("Error while logging in...");
              },
              child: Text(
                "Login Anonymously",
                style: TextStyle(
                  fontSize: 20.0,
                  //TODO: think of the text color for button
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

