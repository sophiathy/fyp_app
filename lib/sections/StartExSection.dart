import 'package:flutter/material.dart';
import 'package:fyp_app/services/screenArguments.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/exerciseBtn.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:fyp_app/widgets/toggleTrackingModeBtn.dart';
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
  Box<int> settingsBox = Hive.box(
      'settings'); //key 0: store the tracking mode (manual = 0 / auto = 1), unlock "Auto" requirements(key 20-24)

  int trackingModeKey = 0;
  int isAuto = 0;

  int unlockKey = 24;

  @override
  void initState() {
    super.initState();
    setState(() {
      isAuto = settingsBox.get(trackingModeKey, defaultValue: 0); //key 0: manual = 0, auto = 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      height: getProportionHeight(160.0),
      title: "Start an Exercise",
      topRightButton:
      //toggle tracking mode (manual or auto) (only show it when auto is unlocked)
      (settingsBox.get(unlockKey, defaultValue: 0) == 0)    //key 24: if 0, auto mode is locked
      ? SizedBox(width: 0.0)
      : Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              setState(() {
                isAuto = 0;
                settingsBox.put(trackingModeKey, isAuto);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: isAuto == 0 ? kPrimaryColor_light : kDisabled,
              padding: EdgeInsets.all(getProportionWidth(2.0)),
              minimumSize: Size(getProportionWidth(55.0), getProportionHeight(18.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(getProportionWidth(8.0)),
                      bottomLeft: Radius.circular(getProportionWidth(8.0)))),
            ),
            child: Text(
              "Manual".toUpperCase(),
              style: TextStyle(
                fontSize: getProportionWidth(10.0),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isAuto = 1;
                settingsBox.put(trackingModeKey, isAuto);
              });
            },
            style: ElevatedButton.styleFrom(
              primary: isAuto == 0 ? kDisabled : kStopOrAutoBtn,
              padding: EdgeInsets.all(getProportionWidth(2.0)),
              minimumSize: Size(getProportionWidth(42.0), getProportionHeight(18.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(getProportionWidth(8.0)),
                      bottomRight: Radius.circular(getProportionWidth(8.0))))
            ),
            child: Text(
              "Auto".toUpperCase(),
              style: TextStyle(
                fontSize: getProportionWidth(10.0),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      content:
        settingsBox.get(trackingModeKey, defaultValue: 0) == 0
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
                  // ExerciseBtn(
                  //   modeSwitch: widget.modeSwitch,
                  //   workoutType: "Cycling",
                  //   press: () {},
                  // ),
                ],
              ),
            )
          : Buttons(
              name: "Start Tracking",
              press: () {
                Navigator.of(context).pushReplacementNamed(
                    '/workingOut',
                    arguments: ScreenArguments(-1, "Auto", [], [],
                        "00:00:00", 0.0, [], "0", 0.0, 0.0));
              }),
    );
  }
}
