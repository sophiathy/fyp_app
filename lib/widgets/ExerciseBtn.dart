import 'package:flutter/material.dart';
import 'package:fyp_app/services/screenArguments.dart';
import 'package:fyp_app/theme/constants.dart';

class ExerciseBtn extends StatelessWidget {
  final bool modeSwitch;
  final String workoutType;
  final Function press;

  const ExerciseBtn({
    Key key,
    @required this.modeSwitch,
    this.workoutType,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 120.0,
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: modeSwitch ? kIconBg_dark : kSectionBackground_light,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: modeSwitch ? kIconBg_dark : kBorder_light,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0), //shape of tapping
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/workingOut',
                arguments: ScreenArguments(
                    workoutType, [], [], "00:00:00", 0.0, [], "0", 0.0, 0.0));
          },
          child: Column(
            children: <Widget>[
              _typeIcon(workoutType),
              SizedBox(height: 5.0),
              Text(
                workoutType,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//check the exercise type and return icon
Widget _typeIcon(String type) {
  final icolor = Colors.lightBlueAccent[700];
  final double isize = 50.0;
  final double isizeStairs = 32.0;

  if (type == "Walking") {
    return Icon(
      Icons.directions_walk_rounded,
      color: icolor,
      size: isize,
    );
  } else if (type == "Walking Upstairs") {
    return Icon(
      Icons.trending_up_rounded,
      color: icolor,
      size: isizeStairs,
    );
  } else if (type == "Walking Downstairs") {
    return Icon(
      Icons.trending_down_rounded,
      color: icolor,
      size: isizeStairs,
    );
  } else if (type == "Running") {
    return Icon(
      Icons.directions_run_rounded,
      color: icolor,
      size: isize,
    );
  } else if (type == "Cycling") {
    return Icon(
      Icons.directions_bike_rounded,
      color: icolor,
      size: isize,
    );
  }
}
