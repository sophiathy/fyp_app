import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/screens/account/errorMessage.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authenticate = AuthService();

  final _formKey = GlobalKey <FormState>();
  final List <String> errors = [];

  bool loginLoading = false;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return loginLoading ? Loading() : Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: SafeArea(
                  top: true,
                  left: true,
                  right: true,
                  child: Text(
                    "Register an Account",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                      .textTheme
                      .headline3
                  ),
                ),
              ),

              //login form
              Form(
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
                            email = data;
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
                            password = data;
                            errors.add(kPasswordNull);
                          });
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 25),

                    ErrorMessage(errors: errors),

                    SizedBox(height: 15),

                    //register button
                    Buttons(
                      name: "Register",
                      press: (){
                        if(_formKey.currentState.validate())
                          print(email);
                          print(password);
                          _formKey.currentState.save();
                          /*TODO:Register button
                          setState(() => loginLoading = true);

                          dynamic getResult = await _authenticate.signInWithEmailAndPassword(email, password); //null or Firebase user

                          if(getResult == null){
                            setState((){
                              if(!errors.contains(kAccountNotFound))
                                errors.add(kAccountNotFound);
                              loginLoading = false;
                            });
                          }*/
                      },
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}