import 'package:flutter/material.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/exerciseBtn.dart';

class StartExSection extends StatelessWidget {
  final bool modeSwitch;
  
  const StartExSection({
    Key key,
    @required this.modeSwitch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).indicatorColor,
        borderRadius: BorderRadius.circular(36.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Start an Exercise".toUpperCase(),
            style: TextStyle(
              color: modeSwitch? kPrimaryColor_dark : kPrimaryColor_light,
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
