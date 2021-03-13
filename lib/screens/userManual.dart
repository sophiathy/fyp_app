import 'package:flutter/material.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/widgets/manualContent.dart';
import 'package:fyp_app/widgets/pageIndicator.dart';
import 'package:provider/provider.dart';

class UserManual extends StatefulWidget {
  @override
  _UserManualState createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  List<Widget> guides = [
    ManualContent(
      image: "assets/images/manual_1.svg",
      title: "Welcome to Exercise Tracker!",
      desc: "App for tracking your workout details",
    ),
    ManualContent(
      image: "assets/images/manual_2.svg",
      title: "Easy to Use,\nRecord Every Workout Moment",
      desc:
          "When you are using Exercise Tracker, you physical activity can be\nrecorded easily.",
    ),
    ManualContent(
      image: "assets/images/manual_3.svg",
      title: "Input Workout Type",
      desc: "Input a workout type and start the stopwatch to begin tracking.",
    ),
    ManualContent(
      image: "assets/images/manual_4.svg",
      title: "Improve Your Workout Performance",
      desc:
          "After the workout, Exercise Tracker\nwill generate a summary for you to understand more about your\nworkout performance.",
    ),
    ManualContent(
      image: "assets/images/manual_5.svg",
      title: "Auto Tracking",
      desc:
          "After recording a number of workouts, Exercise Tracker will start to recognize your physical activity automatically.",
    ),
    ManualContent(
      image: "assets/images/manual_6.svg",
      title: "Stay Tuned",
      desc:
          "More functions and types of\nexercise for you to choose in\nthe coming updates.",
    ),
  ];

  int currentPageNo = 0;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0); //start at first page (0)
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DarkProvider modeSwitch = Provider.of<DarkProvider>(context);

    return new WillPopScope(
      onWillPop: () async => false, //disable the system back button
      child: Scaffold(
        backgroundColor: modeSwitch.themeData ? kIconBg_dark : Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity, //center everything
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: PageView.builder(
                        controller: _controller,
                        onPageChanged: (value) {
                          setState(() => currentPageNo = value);
                        },
                        itemCount: guides.length,
                        itemBuilder: (context, index) {
                          return guides[index];
                        }),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              guides.length,
                              (index) => PageIndicator(
                                  current: currentPageNo, pageNo: index),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                //Skip button > return Home
                                (currentPageNo != guides.length - 1)
                                    ? TextButton(
                                        onPressed: (() => Navigator.of(context)
                                            .pushReplacementNamed("/home")),
                                        child: Text(
                                          "Skip".toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: kDisabled,
                                          ),
                                        ),
                                      )
                                    : SizedBox(width: 0.0),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    //last page > return home
                                    if (currentPageNo == guides.length - 1)
                                      Navigator.of(context)
                                          .pushReplacementNamed("/home");

                                    //press button to navigate between pages
                                    _controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.bounceIn);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    //button background color
                                    primary: kPrimaryColor_light,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                        vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                10.0)),
                                  ),
                                  child: Text(
                                    (currentPageNo == guides.length - 1)
                                        ? "Got it!".toUpperCase()
                                        : "Next".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
