import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/screens/account_auth/errorMessage.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authenticate = AuthService();

  final _formKey = GlobalKey <FormState>();
  final List <String> errors = [];

  bool loginLoading = false;

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
                padding: const EdgeInsets.symmetric(vertical: 80.0),
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
                          /*TODO:Login button
                          setState(() => loginLoading = true);

                          dynamic getResult = await _authenticate.signInWithEmailAndPassword(email, pwd); //null or Firebase user

                          if(getResult == null){
                            setState((){
                              if(!errors.contains(kAccountNotFound))
                                errors.add(kAccountNotFound);
                              loginLoading = false;
                            });
                          }*/
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
                          setState(() => loginLoading = true);

                          dynamic getResult = await _authenticate.signInAnon(); //null or Firebase user

                          if(getResult != null){
                            print("Logged In as");
                            print(getResult);
                          }else{
                            print("Error while logging in...");
                            setState((){
                              if(!errors.contains(kAnonymousLoginError))
                                errors.add(kAnonymousLoginError);
                              loginLoading = false;
                            });
                          }
                        },
                        child: Text(
                          "Login Anonymously",
                          style: TextStyle(
                            fontSize: 20.0,
                            //TODO: think of the text color of button
                            color: Colors.white,
                          ),
                        ),
                      ),
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