import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/sections/startExSection.dart';
import 'package:fyp_app/sections/summarySection.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/loading.dart';
import 'package:fyp_app/widgets/settingsDrawer.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String _profileImage = "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260";
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    DarkProvider modeSwitch = Provider.of<DarkProvider>(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    // final AuthAccount _authenticate = AuthAccount();

    return _loading
        ? Loading()
        : new WillPopScope(
            onWillPop: () async => false, //disable the system back button
            child: Scaffold(
              key: _scaffoldKey,          //pass the global key to SettingsDrawer (do not contain any scaffold)
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).backgroundColor,
              endDrawer: SettingsDrawer(),            //Settings: Edit Profile, User Manual, Logout
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    //app bar
                    SafeArea(
                      top: true,
                      left: true,
                      right: true,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            //mode switcher
                            IconButton(
                              //TODO:Explain in report
                              onPressed: () {
                                setState(() => modeSwitch.themeData =
                                    !modeSwitch.themeData);
                              },
                              icon: modeSwitch.themeData
                                  ? Icon(
                                      //sunny icon in dark mode
                                      Icons.wb_sunny,
                                      size: 28.0,
                                      color: kSectionBackground_light,
                                    )
                                  : Icon(
                                      //moon icon in light mode
                                      Icons.brightness_2,
                                      size: 28.0,
                                      color: kSectionBackground_dark,
                                    ),
                            ),

                            Spacer(),

                            //Settings
                            IconButton(
                              icon: Icon(
                                Icons.settings,
                                size: 35.0,
                                color: modeSwitch.themeData
                                    ? kPrimaryColor_dark
                                    : kPrimaryColor_light,
                              ),
                              onPressed: (() =>
                                  _scaffoldKey.currentState.openEndDrawer()),
                            ),
                            // Material(
                            //   color: Colors.transparent,
                            //   child: InkWell(
                            //     borderRadius: BorderRadius.circular(20.0),
                            //     onTap: () async {
                            //       setState(() {
                            //         modeSwitch.themeData =
                            //             false; //reset to light mode
                            //         print("Logout Successfully.");
                            //       });

                            //       await _authenticate
                            //           .logout(); //update the stream to null
                            //       Navigator.of(context).pushNamedAndRemoveUntil(
                            //           '/login',
                            //           (Route<dynamic> route) => false);
                            //     },
                            //     child: Container(
                            //       height: 32.0,
                            //       width: 32.0,
                            //       decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         image: DecorationImage(
                            //           image: NetworkImage(_profileImage),
                            //           fit: BoxFit.fill,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),

                    //Today's Summary
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: SummarySection(modeSwitch: modeSwitch.themeData),
                    ),

                    //Start an Exercise
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: StartExSection(modeSwitch: modeSwitch.themeData),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
