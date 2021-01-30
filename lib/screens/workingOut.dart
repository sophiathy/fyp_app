import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/services/screenArguments.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/showMap.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:fyp_app/widgets/sensorsInfo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class WorkingOut extends StatefulWidget {
  final String workoutType;

  const WorkingOut({
    Key key,
    @required this.workoutType,
  }) : super(key: key);

  @override
  _WorkingOutState createState() => _WorkingOutState();
}

class _WorkingOutState extends State<WorkingOut> {
  final geo = GeoService();
  static const platform = const MethodChannel('flutter.native/classifier');

  List<String> _results = [];
  String _biking = "",
      _downstairs = "",
      _jogging = "",
      _sitting = "",
      _standing = "",
      _upstairs = "",
      _walking = "";

  Timer _timer;
  Timer _sw;

  //stopwatch
  bool startPressed = false;
  String stopwatchTime = "00:00:00";
  var sw = Stopwatch();
  final duration = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) {
        _getResults();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    if (_sw != null) _sw.cancel();
  }

  Future<void> _getResults() async {
    String biking, downstairs, jogging, sitting, standing, upstairs, walking;

    try {
      _results = await platform.invokeListMethod('getResults');
      biking = "Biking: \t" + _results[0];
      downstairs = "Downstairs: \t" + _results[1];
      jogging = "Jogging: \t" + _results[2];
      sitting = "Sitting: \t" + _results[3];
      standing = "Standing: \t" + _results[4];
      upstairs = "Upstairs: \t" + _results[5];
      walking = "Walking: \t" + _results[6];
    } on PlatformException catch (e) {
      biking = "Failed to get the result: '${e.message}'";
      downstairs = "Failed to get the result: '${e.message}'";
      jogging = "Failed to get the result: '${e.message}'";
      sitting = "Failed to get the result: '${e.message}'";
      standing = "Failed to get the result: '${e.message}'";
      upstairs = "Failed to get the result: '${e.message}'";
      walking = "Failed to get the result: '${e.message}'";
    }

    setState(() {
      _biking = biking;
      _downstairs = downstairs;
      _jogging = jogging;
      _sitting = sitting;
      _standing = standing;
      _upstairs = upstairs;
      _walking = walking;
    });
  }

  void runningWatch() {
    if (sw.isRunning) _sw = Timer(duration, runningWatch);

    //if the width of string of hours/minutes/seconds is less than 2, then add "0" to its left
    //remainder of 60s = minutes
    setState(() {
      stopwatchTime = sw.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (sw.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (sw.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  void startStopwatch() {
    setState(() {
      startPressed = true;
    });
    print("Start to workout... ");
    sw.start();
    _sw =
        Timer(duration, runningWatch); //runningWatch is invoked in every second
  }

  void stopStopwatch() {
    print("Duration of workout: " + stopwatchTime);
    sw.stop();
    if (_sw == null)
      Navigator.of(context).pushReplacementNamed('/home');
    else {
      Navigator.of(context).pushReplacementNamed('/workoutSummary',
          arguments: ScreenArguments(
            widget.workoutType,
            stopwatchTime,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //disable the system back button
      child: FutureProvider(
        create: (content) =>
            geo.getCurrentLocation(), //current location of the user
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
            children: <Widget>[
              SafeArea(
                top: true,
                left: true,
                right: true,
                child: Align(
                  alignment: Alignment.center,
                  child:
                      Consumer<Position>(builder: (context, position, widget) {
                    return (position == null)
                        ? Center(child: CircularProgressIndicator())
                        : ShowMap(position); //TODO: comment
                  }),
                ),
              ),
              SizedBox.expand(
                child: DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    minChildSize: 0.20,
                    maxChildSize: 0.8,
                    builder: (BuildContext context, scrollCon) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(36.0),
                            topRight: Radius.circular(36.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0,
                            )
                          ],
                        ),
                        child: ListView(
                          controller: scrollCon,
                          padding: const EdgeInsets.all(6.0),
                          children: <Widget>[
                            SizedBox(height: 6.0),

                            Center(
                              child: Container(
                                height: 7.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[200],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),

                            SizedBox(height: 12.0),

                            Stack(
                              children: <Widget>[
                                SectionCard(
                                  height: 460.0,
                                  title:
                                      "Workout Details (${widget.workoutType})",
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 70.0, left: 24.0, right: 24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            stopwatchTime,
                                            style: TextStyle(
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          RaisedButton(
                                            onPressed: startStopwatch,
                                            color: startPressed
                                                ? Colors.blueGrey[300]
                                                : Colors.greenAccent[400],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 10.0),
                                            child: Text(
                                              "Start".toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          RaisedButton(
                                            onPressed: stopStopwatch,
                                            color: startPressed
                                                ? Colors.redAccent
                                                : Colors.blueGrey[300],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 10.0),
                                            child: Text(
                                              "Stop".toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 10.0),

                                      SensorsInfo(
                                          workoutType: widget.workoutType),

                                      //classifying the type of physical activities
                                      SizedBox(height: 10.0),
                                      Text(_biking),
                                      SizedBox(height: 10.0),
                                      Text(_downstairs),
                                      SizedBox(height: 10.0),
                                      Text(_jogging),
                                      SizedBox(height: 10.0),
                                      Text(_sitting),
                                      SizedBox(height: 10.0),
                                      Text(_standing),
                                      SizedBox(height: 10.0),
                                      Text(_upstairs),
                                      SizedBox(height: 10.0),
                                      Text(_walking),
                                      SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(24.0),
                            //   child: Buttons(
                            //     name: "End",
                            //     press: (() => Navigator.of(context).pushReplacementNamed(
                            //         '/workoutSummary',
                            //         arguments: widget.workoutType)),
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
