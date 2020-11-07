import 'package:flutter/material.dart';
import 'package:fyp_app/widgets/exerciseBtn.dart';
import 'package:fyp_app/widgets/sectionCard.dart';

class StartExSection extends StatelessWidget {
  final bool modeSwitch;

  const StartExSection({
    Key key,
    @required this.modeSwitch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SectionCard(
          height: 180.0,
          title: "Start an Exercise",
        ),

        //buttons of exercise
        Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 24.0, right: 24.0),
          child: SingleChildScrollView(
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
        ),
      ],
    );
  }
}
