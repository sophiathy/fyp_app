import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:hive/hive.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SummarySection extends StatefulWidget {
  final bool modeSwitch;

  const SummarySection({
    Key key,
    @required this.modeSwitch,
  }) : super(key: key);

  @override
  _SummarySectionState createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection> {
  //pedometer
  StreamSubscription<StepCount> _pedoSub;
  int _todaySteps;
  String _steps = "0";
  Box<int> pedoBox = Hive.box('steps'); //store last saved steps counted
  Box<int> todaysDurationBox =
      Hive.box('todaysDuration'); //store last saved today's workout seconds
  Box<double> todaysDistanceBox =
      Hive.box('todaysDistance'); //store last saved today's workout distance

  @override
  void initState() {
    super.initState();
    if (mounted)
      //stream subscriptions on Pedometer
      setUpPedometer();
  }

  @override
  void dispose() {
    // _pedoSub.cancel();     //if cancel, the pedometer will not update the steps value
    super.dispose();
  }

  void setUpPedometer() {
    _pedoSub = Pedometer.stepCountStream.listen(stepsToday, onError: stepError);
  }

  Future<int> stepsToday(StepCount streamCount) async {
    int lastSavedYearKey = 40;
    int lastSavedMonthKey = 41;
    int lastSavedDayKey = 42;
    int lastSavedStepsKey = 43;
    int todayYear = DateTime.now().year;
    int todayMonth = DateTime.now().month;
    int todayDay = DateTime.now().day; //1-31 = key in hive

    int lastSavedYear = pedoBox.get(lastSavedYearKey, defaultValue: 0);
    int lastSavedMonth = pedoBox.get(lastSavedMonthKey, defaultValue: 0);
    int lastSavedDay = pedoBox.get(lastSavedDayKey, defaultValue: 0);

    int lastSavedSteps = pedoBox.get(lastSavedStepsKey,
        defaultValue: 0); //if does not exist in pedoBox, its value = 0

    //pedometer will be reset when the device reboots => reset value to 0
    if (lastSavedSteps > streamCount.steps) {
      lastSavedSteps = 0;
      pedoBox.put(lastSavedStepsKey, lastSavedSteps);
    }

    //save the most updated timestamp and steps counted
    if (lastSavedYear < todayYear ||
        lastSavedMonth < todayMonth ||
        lastSavedDay < todayDay) {
      lastSavedYear = todayYear;
      lastSavedMonth = todayMonth;
      lastSavedDay = todayDay;
      lastSavedSteps = streamCount.steps;

      pedoBox.put(lastSavedYearKey, lastSavedYear);
      pedoBox.put(lastSavedMonthKey, lastSavedMonth);
      pedoBox.put(lastSavedDayKey, lastSavedDay);
      pedoBox.put(lastSavedStepsKey, lastSavedSteps);
    }

    //total steps counted by pedometer - last saved total = today's steps
    setState(() {
      _todaySteps = (streamCount.steps - lastSavedSteps);
      _steps = _todaySteps.toString();
    });

    pedoBox.put(
        todayDay, _todaySteps); //store back to one of the location 1-31 in hive

    return _todaySteps; //return back to the pedometer stream
  }

  void stepError(error) {
    setState(() {
      print("Cannot count steps: $error");
      _steps = "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      height: getProportionHeight(214.0),
      title: "Today's Summary",
      topRightButton: SizedBox(width: 0.0),
      content:
        Container(
          height: getProportionWidth(165.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: getProportionWidth(30.0)),

              //today's steps percentage indicator
              //pedometer's value will reset to 0 if user restart his/her smartphone
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularPercentIndicator(
                      radius: getProportionWidth(115.0),
                      lineWidth: getProportionWidth(10.0),
                      animateFromLastPercent: true,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: (_steps != "N/A")
                          ? (double.parse(_steps) / 10000.0)
                          : 0.0,
                      center: Text(
                        _steps,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.green,
                              fontSize: getProportionWidth(22.0),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      progressColor: Colors.green,
                      backgroundColor:
                          widget.modeSwitch ? kIconBg_dark : kIconBg_light,
                    ),
                    SizedBox(height: getProportionHeight(10.0)),
                    Text(
                      "Steps",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.green,
                            fontSize: getProportionWidth(16.0),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: getProportionWidth(45.0)),

              //workout minutes & distance
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: getProportionWidth(36.0),
                            width: getProportionWidth(36.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.modeSwitch
                                  ? kIconBg_dark
                                  : kIconBg_light.withOpacity(0.5),
                            ),
                            child: Icon(
                              Icons.timer_rounded,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(width: getProportionWidth(12.0)),
                          Text(
                            (todaysDurationBox.get(DateTime.now().day,
                                        defaultValue: 0) ~/
                                    60 /
                                    60)
                                .toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                  color: Colors.pink,
                                  fontSize: getProportionWidth(28.0),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(width: getProportionWidth(8.0)),
                          Text(
                            "hours",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                  color: Colors.pink,
                                  fontSize: getProportionWidth(12.0),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: getProportionWidth(36.0),
                            width: getProportionWidth(36.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.modeSwitch
                                  ? kIconBg_dark
                                  : kIconBg_light.withOpacity(0.5),
                            ),
                            child: Icon(
                              Icons.place_outlined,
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(width: getProportionWidth(12.0)),
                          Text(
                            todaysDistanceBox
                                .get(DateTime.now().day, defaultValue: 0)
                                .toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                  color: Colors.amber,
                                  fontSize: getProportionWidth(28.0),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(width: getProportionWidth(8.0)),
                          Text(
                            "km",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                  color: Colors.amber,
                                  fontSize: getProportionWidth(12.0),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
