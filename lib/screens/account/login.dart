import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/screens/account/errorMessage.dart';
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
  bool attempt = false;
  String email = "";
  String password = "";
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loginLoading ? Loading() : Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap:(){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          //prefixIcon color based on primaryColor
                          prefixIcon: Icon(
                            Icons.email_rounded,
                          ),
                          hintText: "Enter your email",
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              splashColor: Colors.indigo[50],
                              onTap: (){
                                this.setState(() => _emailController.clear());
                              },
                              child: Icon(
                                Icons.backspace_rounded,
                                color: Colors.indigo[100],
                                size: 25.0,
                              ),
                            ),
                          ),
                          //floatingLabel must be added here, it won't work in theme.dart
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (data){
                          if(data.isEmpty){
                            setState(() => errors.remove(kInvalidEmail));

                            if(!errors.contains(kEmailNull))
                              setState(() => errors.add(kEmailNull)); //if the message is not inside the List "errors", then add

                            print(kEmailNull);
                            return "";                              //return email = ""
                          }else if(!emailRegExp.hasMatch(data)){
                            setState(() => errors.remove(kEmailNull));

                            if(!errors.contains(kInvalidEmail))
                              setState(() => errors.add(kInvalidEmail));

                            print(kInvalidEmail);
                            return "";
                          }

                          return null;
                        },
                        onSaved: (data) => email = data,  //when the form is saved, capture the value
                        onChanged: (data){
                          if(attempt){
                            setState(() => errors.remove(kAccountNotFound));
                            attempt = false;
                          }

                          if(data.isNotEmpty)
                            setState(() => errors.remove(kEmailNull));
                          else if(emailRegExp.hasMatch(data))
                            setState(() => errors.remove(kInvalidEmail));
                          return null;
                        },
                      ),

                      SizedBox(height: 25),

                      //password field
                      TextFormField(
                        //hide password
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                          ),
                          hintText: "Enter your password",
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              splashColor: Colors.indigo[50],
                              onTap: (){
                                this.setState(() => _passwordController.clear());
                              },
                              child: Icon(
                                Icons.backspace_rounded,
                                color: Colors.indigo[100],
                                size: 25.0,
                              ),
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (data){
                          if(data.isEmpty){
                            if(!errors.contains(kPasswordNull))
                              setState(() => errors.add(kPasswordNull));

                            print(kPasswordNull);
                            return "";                  //return password = ""
                          }

                          return null;
                        },
                        onSaved: (data) => password = data,  //when the form is saved, capture the value
                        onChanged: (data){
                          if(attempt){
                            setState(() => errors.remove(kAccountNotFound));
                            attempt = false;
                          }

                          if(data.isNotEmpty)
                            setState(() => errors.remove(kPasswordNull));

                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      ErrorMessage(errors: errors),

                      SizedBox(height: 15),

                      //login button
                      Buttons(
                        name: "Login",
                        press: () async{
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();

                            dynamic getResult = await _authenticate.loginEmailPassword(email, password); //null or Firebase user

                            if(getResult != null){
                              if(errors.contains(kAccountNotFound))
                                  errors.remove(kAccountNotFound);
                              print("Logged in as: " + email);
                              loginLoading = true;
                            }else{
                              setState((){
                                //FIXME: if empty email and password, still return this result
                                if(!errors.contains(kAccountNotFound)){
                                  errors.add(kAccountNotFound);
                                  print(kAccountNotFound);
                                }

                                attempt = true;
                                loginLoading = false;
                              });
                            }
                          }
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

                            dynamic getResult = await _authenticate.loginAnon(); //null or Firebase user

                            if(getResult != null){
                              print("Logged in as: " + getResult.uid);
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
      ),
    );
  }
}