import 'dart:async';

import 'package:flutter/material.dart';
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
  StreamSubscription<StepCount> _streamSub;
  int _todaySteps;
  String _steps = "0";
  Box<int> pedoBox = Hive.box('steps'); //store last saved timestamp and steps
  Box<int> workoutDurationBox = Hive.box('workoutDuration'); //store last saved workout seconds

  @override
  void initState() {
    super.initState();
    if (mounted)
      //stream subscriptions on Pedometer
      setUpPedometer();
  }

  @override
  void dispose() {
    // _streamSub.cancel();
    super.dispose();
  }

  void setUpPedometer() {
    _streamSub =
        Pedometer.stepCountStream.listen(stepsToday, onError: stepError);
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
    return Stack(
      children: <Widget>[
        SectionCard(
          height: 270.0,
          title: "Today's Summary",
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Container(
            height: 200.0,
            child: Row(
              children: <Widget>[
                SizedBox(width: 30.0),

                //today's steps percentage indicator
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 135.0,
                        lineWidth: 12.0,
                        animateFromLastPercent: true,
                        circularStrokeCap: CircularStrokeCap.round,
                        percent: (_steps != "N/A")
                            ? (double.parse(_steps) / 10000.0)
                            : 0.0,
                        center: Text(
                          _steps,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.green,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        progressColor: Colors.green,
                        backgroundColor:
                            widget.modeSwitch ? kIconBg_dark : kIconBg_light,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Steps".toUpperCase(),
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.green,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 35.0),

                //workout minutes & burned calories
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 35.0,
                              width: 35.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.modeSwitch
                                    ? kIconBg_dark
                                    : kIconBg_light,
                              ),
                              child: Icon(
                                Icons.timer,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              (workoutDurationBox.get(DateTime.now().day, defaultValue: 0)~/60).toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.blue,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Workout\nMinutes".toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.blue,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 35.0,
                              width: 35.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.modeSwitch
                                    ? kIconBg_dark
                                    : kIconBg_light,
                              ),
                              child: Icon(
                                Icons.local_fire_department,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "8334",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.amber,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Burned\nCalories".toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                    color: Colors.amber,
                                    fontSize: 12.0,
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
        ),
      ],
    );
  }
}
