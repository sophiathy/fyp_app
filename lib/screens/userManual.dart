import 'package:flutter/material.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/manualContent.dart';
import 'package:fyp_app/widgets/pageIndicator.dart';

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
      title: "Welcome to Exercise Tracker!",
      desc: "blablabla",
    ),
    ManualContent(
      image: "assets/images/manual_3.svg",
      title: "Welcome to Exercise Tracker!",
      desc: "blablabla",
    ),
    ManualContent(
      image: "assets/images/manual_4.svg",
      title: "Welcome to Exercise Tracker!",
      desc: "blablabla",
    ),
    ManualContent(
      image: "assets/images/manual_5.svg",
      title: "Welcome to Exercise Tracker!",
      desc: "blablabla",
    ),
    ManualContent(
      image: "assets/images/manual_6.svg",
      title: "Welcome to Exercise Tracker!",
      desc: "blablabla",
    ),
  ];

  int currentPageNo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).indicatorColor,
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
                              RaisedButton(
                                onPressed: (() => Navigator.of(context).pop()),
                                color: kDisabled,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            10.0)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 10.0),
                                child: Text(
                                  "Skip".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Spacer(),
                              RaisedButton(
                                onPressed: (){},
                                color: kPrimaryColor_light,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            10.0)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 10.0),
                                child: Text(
                                  "Next".toUpperCase(),
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
    );
  }
}
