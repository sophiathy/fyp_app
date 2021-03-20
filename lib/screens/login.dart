import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/errorMessage.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthAccount _authenticate = AuthAccount();

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];

  bool _loginLoading = true;
  String email = "";
  String password = "";
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() => _loginLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loginLoading
        ? Loading()
        : new WillPopScope(
            onWillPop: () async => false, //disable the system back button
            child: Scaffold(
              // resizeToAvoidBottomInset: false,     //if use, cannot scroll the form
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionWidth(16.0)),
                  child: SafeArea(
                    child: Container(
                      height: getProportionHeight(500.0),
                      width: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: getProportionWidth(50.0)),
                            child: SafeArea(
                              child: Text("Exercise\nTracker",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline3),
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
                                        borderRadius: BorderRadius.circular(getProportionWidth(30.0)),
                                        splashColor: Colors.indigo[50],
                                        onTap: () {
                                          this.setState(
                                              () => _emailController.clear());
                                        },
                                        child: Icon(
                                          Icons.backspace_rounded,
                                          color: Colors.indigo[100],
                                          size: getProportionWidth(23.0),
                                        ),
                                      ),
                                    ),
                                    //floatingLabel must be added here, it won't work in theme.dart
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  validator: (data) {
                                    if (data.isEmpty) {
                                      setState(
                                          () => errors.remove(kInvalidEmail));

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
                                    setState(
                                        () => errors.remove(kAccountNotFound));

                                    if (data.isNotEmpty)
                                      setState(() => errors.remove(kEmailNull));

                                    if (emailRegExp.hasMatch(data))
                                      setState(
                                          () => errors.remove(kInvalidEmail));
                                    return null;
                                  },
                                ),

                                SizedBox(height: getProportionWidth(23.0)),

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
                                        borderRadius: BorderRadius.circular(getProportionWidth(30.0)),
                                        splashColor: Colors.indigo[50],
                                        onTap: () {
                                          this.setState(
                                              () => _passwordController.clear());
                                        },
                                        child: Icon(
                                          Icons.backspace_rounded,
                                          color: Colors.indigo[100],
                                          size: getProportionWidth(23.0),
                                        ),
                                      ),
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  validator: (data) {
                                    setState(
                                        () => errors.remove(kAccountNotFound));

                                    if (data.isEmpty) {
                                      if (!errors.contains(kPasswordNull))
                                        setState(() => errors.add(kPasswordNull));

                                      print(kPasswordNull);
                                      return ""; //return password = ""
                                    }

                                    return null;
                                  },
                                  onSaved: (data) => password =
                                      data, //when the form is saved, capture the value
                                  onChanged: (data) {
                                    setState(
                                        () => errors.remove(kAccountNotFound));

                                    if (data.isNotEmpty)
                                      setState(
                                          () => errors.remove(kPasswordNull));

                                    return null;
                                  },
                                ),

                                SizedBox(height: getProportionWidth(14.0)),

                                ErrorMessage(errors: errors),

                                SizedBox(height: getProportionWidth(12.0)),

                                //login (email & password)
                                Buttons(
                                  name: "Login",
                                  press: () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      dynamic getResult =
                                          await _authenticate.loginEmailPassword(
                                              email,
                                              password); //null or Firebase user

                                      if (getResult != null) {
                                        setState(() {
                                          errors.remove(kAccountNotFound);
                                          print("Logged in as: " + email);
                                        });
                                        Navigator.of(context).pushNamed('/home');
                                      } else {
                                        setState(() {
                                          if (!errors
                                              .contains(kAccountNotFound)) {
                                            errors.add(kAccountNotFound);
                                            print(kAccountNotFound);
                                          }
                                        });
                                      }
                                    }
                                  },
                                ),

                                SizedBox(height: getProportionWidth(38.0)),

                                // Center(
                                //   child: Text(
                                //     "Don't have an account?",
                                //     style: TextStyle(
                                //       fontSize: 20.0,
                                //       color: Colors.indigo[300],
                                //     ),
                                //   ),
                                // ),

                                // SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Don't have an account?",
                                      style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                              color: Colors.indigo[300],
                                              fontSize: getProportionWidth(16.0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                    ),
                                    SizedBox(width: getProportionWidth(14.0)),
                                    SizedBox(
                                      width: getProportionWidth(125.0),
                                      height: getProportionWidth(48.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          //button background color
                                          primary: Colors.indigo[300],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      getProportionWidth(13.0))),
                                        ),
                                        onPressed: (() => Navigator.of(context)
                                            .pushNamed('/register')),
                                        child: Text(
                                          "Register".toUpperCase(),
                                          style: TextStyle(
                                            fontSize: getProportionWidth(16.0),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // SizedBox(width: 10.0),

                                    // Text(
                                    //   "or",
                                    //   style: TextStyle(
                                    //     fontSize: 16.0,
                                    //     color: Colors.indigo[300],
                                    //   ),
                                    // ),

                                    // SizedBox(width: 10.0),

                                    // //login (anonymous)
                                    // SizedBox(
                                    //   width: 200.0,
                                    //   height: 50.0,
                                    //   child: FlatButton(
                                    //     color: Colors.indigo[300],
                                    //     shape: RoundedRectangleBorder(
                                    //         borderRadius:
                                    //             BorderRadius.circular(15.0)),
                                    //     onPressed: () async {
                                    //       dynamic getResult = await _authenticate
                                    //           .loginAnon(); //null or Firebase user

                                    //       if (getResult != null) {
                                    //         print(
                                    //             "Logged in as: " + getResult.uid);
                                    //         Navigator.of(context)
                                    //             .pushNamed('/home');
                                    //       } else {
                                    //         print("Error while logging in...");
                                    //         setState(() {
                                    //           if (!errors
                                    //               .contains(kAnonymousLoginError))
                                    //             errors.add(kAnonymousLoginError);
                                    //         });
                                    //       }
                                    //     },
                                    //     child: Text(
                                    //       "Login Anonymously",
                                    //       style: TextStyle(
                                    //         fontSize: 18.0,
                                    //         color: Colors.white,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
