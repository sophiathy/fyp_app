import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/sections/recordsSection.dart';
import 'package:fyp_app/services/checkPermission.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/sections/startExSection.dart';
import 'package:fyp_app/sections/summarySection.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/autoRequirementsDialog.dart';
import 'package:fyp_app/widgets/autoUnlockDialog.dart';
import 'package:fyp_app/widgets/loading.dart';
import 'package:fyp_app/widgets/settingsDrawer.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  Box<int> settingsBox = Hive.box(
      'settings'); //key 0: store the tracking mode (manual = 0 / auto = 1), unlock "Auto" requirements(key 20-24)
  int trackingModeKey = 0;
  int unlockKey = 24;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() => _loading = false);
      checkPermission();

      //check unlock auto mode requirements (0=locked, 1=unlock, -1=unlocked already)
      if (settingsBox.get(unlockKey, defaultValue: 0) == 0)
        Future.delayed(
            Duration.zero,
            () => autoRequirementsDialog(
                context)); //notify user the remaining requirements to unlock auto mode
      else if (settingsBox.get(unlockKey, defaultValue: 0) == 1) {
        Future.delayed(
            Duration.zero,
            () => autoUnlockDialog(
                context)); //notify user that auto mode has just been unlocked

        //update auto mode has been unlocked already
        settingsBox.put(unlockKey, -1);

        settingsBox.put(
            trackingModeKey, 1); //change from manual mode to auto mode
      }
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
              key:
                  _scaffoldKey, //pass the global key to SettingsDrawer (do not contain any scaffold)
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).backgroundColor,
              endDrawer:
                  SettingsDrawer(), //Settings: Edit Profile, User Manual, Logout
              body: Padding(
                padding: EdgeInsets.all(getProportionWidth(16.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //app bar
                    SafeArea(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                      size: getProportionWidth(30.0),
                                      color: kSectionBackground_light,
                                    )
                                  : Icon(
                                      //moon icon in light mode
                                      Icons.brightness_2,
                                      size: getProportionWidth(30.0),
                                      color: kSectionBackground_dark,
                                    ),
                            ),

                            Spacer(),
                            Text(
                              "Exercise Tracker",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  .copyWith(
                                    fontSize: getProportionWidth(22.0),
                                  ),
                            ),
                            Spacer(),

                            //Settings
                            IconButton(
                              icon: Icon(
                                Icons.settings,
                                size: getProportionWidth(30.0),
                                color: Theme.of(context).primaryColor,
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

                    ClipRRect(
                      child: Container(
                        width: double.infinity,
                        height: getProportionHeight(543.0),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            //Today's Summary
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionWidth(10.0),
                                  bottom: getProportionWidth(15.0)),
                              child: SummarySection(
                                  modeSwitch: modeSwitch.themeData),
                            ),

                            //Start an Exercise
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionWidth(5.0),
                                  bottom: getProportionWidth(15.0)),
                              child: StartExSection(
                                  modeSwitch: modeSwitch.themeData),
                            ),

                            //Recent Records
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionWidth(5.0),
                                  bottom: getProportionWidth(15.0)),
                              child: RecordsSection(
                                  modeSwitch: modeSwitch.themeData),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
