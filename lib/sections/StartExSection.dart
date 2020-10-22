import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/theme_LightDark.dart';
import 'package:fyp_app/widgets/ExerciseBtn.dart';

class StartExSection extends StatelessWidget {
  const StartExSection({
    Key key,
    @required this.modeSwitch,
  }) : super(key: key);

  final bool modeSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: modeChanger(modeSwitch),
        borderRadius: BorderRadius.circular(36.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Start an Exercise".toUpperCase(),
            style: TextStyle(
              color: modeSwitch? kTextColor_dark : kTextColor_light,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20.0),

          //buttons of exercise
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                ExerciseBtn(
                  modeSwitch: modeSwitch,
                  type: "Walking",
                  press: () {},
                ),

                ExerciseBtn(
                  modeSwitch: modeSwitch,
                  type: "Running",
                  press: () {},
                ),

                ExerciseBtn(
                  modeSwitch: modeSwitch,
                  type: "Biking",
                  press: () {},
                ),

                ExerciseBtn(
                  modeSwitch: modeSwitch,
                  type: "Others",
                  press: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
