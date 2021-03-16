import 'package:flutter/material.dart';
import 'package:fyp_app/services/screenArguments.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/exerciseBtn.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:hive/hive.dart';

class StartExSection extends StatefulWidget {
  final bool modeSwitch;

  const StartExSection({
    Key key,
    @required this.modeSwitch,
  }) : super(key: key);

  @override
  _StartExSectionState createState() => _StartExSectionState();
}

class _StartExSectionState extends State<StartExSection> {
  Box<int> trackingModeBox = Hive.box(
      'trackingMode'); //store the tracking mode (manual = 0 / auto = 1)
  int isAuto = 0;

  @override
  void initState() {
    super.initState();
    setState(() => isAuto =
        trackingModeBox.get(0, defaultValue: 0)); //manual = 0, auto = 1
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SectionCard(
          height: 210.0,
          title: "Start an Exercise",
        ),

        //toggle tracking mode (manual or auto)
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAuto = 0;
                    trackingModeBox.put(0, isAuto);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: isAuto == 0 ? kPrimaryColor_light : kDisabled,
                  padding: EdgeInsets.all(3.0),
                  minimumSize: Size(66.0, 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                ),
                child: Text(
                  "Manual".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAuto = 1;
                    trackingModeBox.put(0, isAuto);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: isAuto == 0 ? kDisabled : kStopOrAutoBtn,
                  padding: EdgeInsets.all(3.0),
                  minimumSize: Size(50.0, 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                ),
                child: Text(
                  "Auto".toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        //buttons of exercise (depends on the tracking mode)
        Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 24.0, right: 24.0),
          child: isAuto == 0
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ExerciseBtn(
                        modeSwitch: widget.modeSwitch,
                        workoutType: "Walking",
                        press: () {},
                      ),
                      ExerciseBtn(
                        modeSwitch: widget.modeSwitch,
                        workoutType: "Walking Upstairs",
                        press: () {},
                      ),
                      ExerciseBtn(
                        modeSwitch: widget.modeSwitch,
                        workoutType: "Walking Downstairs",
                        press: () {},
                      ),
                      ExerciseBtn(
                        modeSwitch: widget.modeSwitch,
                        workoutType: "Running",
                        press: () {},
                      ),
                      ExerciseBtn(
                        modeSwitch: widget.modeSwitch,
                        workoutType: "Cycling",
                        press: () {},
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Buttons(
                      name: "Start Tracking",
                      press: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/workingOut',
                            arguments: ScreenArguments("Auto", [], [], "00:00:00",
                                0.0, [], "0", 0.0, 0.0));
                      }),
                ),
        ),
      ],
    );
  }
}
