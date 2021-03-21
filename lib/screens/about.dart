import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/sectionCard.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //disable the system back button
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: getProportionWidth(20.0), horizontal: getProportionWidth(16.0)),
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: <Widget>[
                SectionCard(
                  title: "About this App",
                  topRightButton: SizedBox(width: 0.0),
                  content:
                    Column(
                      children: <Widget>[
                        SizedBox(height: getProportionWidth(25.0)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(getProportionWidth(36.0)),
                          child: Container(
                            width: getProportionWidth(150.0),
                            height: getProportionWidth(150.0),
                            child: Image(
                              image: AssetImage("assets/images/appLogo.png"),
                            ),
                          ),
                        ),
                        SizedBox(height: getProportionWidth(35.0)),
                        Text(
                          "Exercise Tracker is an application used for tracking user's physical activities. "+
                          "Sensors data collected from user's smartphone will be used for training a model to identify user's workout types "+
                          "while user's location data will only be used for displaying the user's workout route. "+
                          "All the user data collected will be kept confidential. ",

                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: getProportionWidth(12.0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: getProportionHeight(20.0)),
                        Row(
                          children: <Widget>[
                            Spacer(),
                            Text(
                              "Designed by Tang Ho Yan Sophia\n(Email: sophiathy2@gmail.com)" +
                              "\nFYP Project in 2020/21",
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: getProportionWidth(12.0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: getProportionWidth(20.0)),
                  child: Buttons(
                    name: "Return to Home",
                    press: (() => Navigator.of(context)
                        .pushReplacementNamed('/home')),
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