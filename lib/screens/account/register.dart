import 'package:flutter/material.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/screens/account/errorMessage.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/widgets/buttons.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthAccount _authenticate = AuthAccount();

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  String email = "";
  String password = "";
  String confirmPassword = "";
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                //return to Login
                SafeArea(
                  top: true,
                  left: true,
                  right: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          splashColor: Colors.indigo[50],
                          onTap: (() => Navigator.of(context).pop()),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.indigo[300],
                            size: 25.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text("Register an Account".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5),
                ),

                //register form
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
                              onTap: () {
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
                        validator: (data) {
                          if (data.isEmpty) {
                            setState(() => errors.remove(kInvalidEmail));

                            if (!errors.contains(kEmailNull))
                              setState(() => errors.add(
                                  kEmailNull)); //if the message is not inside the List "errors", then add

                            print(kEmailNull);
                            return ""; //return email = ""
                          } else if (!emailRegExp.hasMatch(data)) {
                            setState(() => errors.remove(kEmailNull));

                            if (!errors.contains(kInvalidEmail))
                              setState(() => errors.add(kInvalidEmail));

                            print(kInvalidEmail);
                            return "";
                          }

                          return null;
                        },
                        onSaved: (data) => email =
                            data, //when the form is saved, capture the value
                        onChanged: (data) {
                          setState(() => errors.remove(kAccountExists));

                          if (data.isNotEmpty)
                            setState(() => errors.remove(kEmailNull));

                          if (emailRegExp.hasMatch(data))
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
                              onTap: () {
                                this.setState(
                                    () => _passwordController.clear());
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
                        validator: (data) {
                          setState(() {
                            errors.remove(kAccountExists);
                            errors.remove(kNotMatchPassword);
                          });

                          if (data.isEmpty) {
                            if (!errors.contains(kPasswordNull))
                              setState(() => errors.add(kPasswordNull));

                            print(kPasswordNull);
                            return ""; //return password = ""
                          } else if (data.length < 6) {
                            if (!errors.contains(kShortPassword))
                              setState(() => errors.add(kShortPassword));

                            print(kShortPassword);
                            return ""; //return password = ""
                          }

                          return null;
                        },
                        onSaved: (data) => password =
                            data, //when the form is saved, capture the value
                        onChanged: (data) {
                          setState(() => errors.remove(kAccountExists));

                          if (data.isNotEmpty) {
                            setState(() => errors.remove(kPasswordNull));
                            if (data.length >= 6)
                              setState(() => errors.remove(kShortPassword));
                          }

                          password = data;
                        },
                      ),

                      SizedBox(height: 25),

                      //confirm password field
                      TextFormField(
                        //hide password
                        obscureText: true,
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                          ),
                          hintText: "Re-enter your password",
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30.0),
                              splashColor: Colors.indigo[50],
                              onTap: () {
                                this.setState(
                                    () => _confirmPasswordController.clear());
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
                        validator: (data) {
                          setState(() => errors.remove(kAccountExists));

                          if (data.isEmpty) {
                            if (!errors.contains(kConfirmPasswordNull))
                              setState(() => errors.add(kConfirmPasswordNull));

                            print(kConfirmPasswordNull);
                            return ""; //return confirmPassword = ""
                          } else if (data != password) {
                            if (!errors.contains(kNotMatchPassword))
                              setState(() => errors.add(kNotMatchPassword));

                            print(kNotMatchPassword);
                            return ""; //return confirmPassword = ""
                          }

                          return null;
                        },
                        onSaved: (data) => confirmPassword =
                            data, //when the form is saved, capture the value
                        onChanged: (data) {
                          setState(() => errors.remove(kAccountExists));

                          if (data.isNotEmpty) {
                            setState(() {
                              errors.remove(kConfirmPasswordNull);
                              errors.remove(kNotMatchPassword);
                            });
                          }

                          confirmPassword = data;
                        },
                      ),

                      SizedBox(height: 20),

                      ErrorMessage(errors: errors),

                      SizedBox(height: 15),

                      //create account button
                      Buttons(
                        name: "Create Account",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            dynamic getResult =
                                await _authenticate.registerEmailPassword(
                                    email, password); //null or Firebase user

                            if (getResult != null) {
                              setState(() {
                                errors.remove(kAccountExists);
                                print("Registered account: " + email);
                              });
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            } else {
                              setState(() {
                                if (!errors.contains(kAccountExists)) {
                                  errors.add(kAccountExists);
                                  print(kAccountExists);
                                }
                              });
                            }
                          }
                        },
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
