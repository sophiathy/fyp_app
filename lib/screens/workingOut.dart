import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/services/screenArguments.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/detailRow.dart';
import 'package:fyp_app/widgets/noRecordToSaveDialog.dart';
import 'package:fyp_app/widgets/showMap.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:wakelock/wakelock.dart';

class WorkingOut extends StatefulWidget {
  final String workoutType;
  final List<int> countActivities;
  final List<LatLng> route;
  final String duration;
  final double totalDistance;
  final List<List<String>> csvRows;
  final String todaySteps;
  final double averageSpeed;
  final double highestSpeed;

  const WorkingOut({
    Key key,
    @required this.workoutType,
    this.countActivities,
    this.route,
    this.duration,
    this.totalDistance,
    this.csvRows,
    this.todaySteps,
    this.averageSpeed,
    this.highestSpeed,
  }) : super(key: key);

  @override
  _WorkingOutState createState() => _WorkingOutState();
}

class _WorkingOutState extends State<WorkingOut> {
  static const platform = const MethodChannel('flutter.native/classifier');

  //showing map, recording the workout route, calculating distance
  final geo = GeoService();
  List<LatLng> _route = [];
  LatLng previous;
  double _totalDistance = 0.0;
  Timer _recordRoute;
  final routeUpdate =
      const Duration(seconds: 5); //the route will be more straighter on the map

  // List<String> _results = [];
  // String _biking = "",
  //     _downstairs = "",
  //     _jogging = "",
  //     _sitting = "",
  //     _standing = "",
  //     _upstairs = "",
  //     _walking = "";
  // String _detectedActivity = "";
  // String _detectedActivityStatus = "";
  // String _detectedActivityTime = "";

  String _result = ""; //store the result returned by the tflite model
  List<String> _detectedActivities = []; //a list of detected activities

  Timer _modelTimer;
  final refresh =
      const Duration(seconds: 1); //used by _modelTimer, _countdown, _sw

  //accelerometer and gyroscope
  List<StreamSubscription<dynamic>> _streamSub =
      <StreamSubscription<dynamic>>[];
  List<double> _accelVal;
  List<double> _gyroVal;

  //speedometer
  double _currentSpeed = 0.0;
  List<double> _allSpeed = [];
  double _averageSpeed = 0.0;
  double _highestSpeed = 0.0;

  //pedometer
  int _todaySteps;
  String _steps = "0";
  Box<int> pedoBox = Hive.box('steps'); //store last saved steps counted

  //countdown timer
  int counter = 3;
  String readyCountdown = "Get Ready!";
  bool tracking = false;
  bool trackingDelay = true;
  Timer _countdown;

  //stopwatch
  bool startPressed = false;
  String stopwatchTime = "00:00:00";
  var sw = Stopwatch();
  Timer _sw;

  //record sensors' data
  bool recording = false;
  List<List<String>> rows = [];
  List<String> row = [];
  Timer _recordSens;
  final sensorUpdate = const Duration(milliseconds: 10);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      //stream subscriptions on Accelerometer and Gyroscope
      setUpAccelerometerGyroscope();
      //stream subscriptions on Pedometer
      setUpPedometer();
      setState(() {
        stopwatchTime = widget.duration; //00:00:00
        if (widget.workoutType == "Auto") {
          _modelTimer = Timer.periodic(refresh, (Timer t) {
            _getResult(); //getting the result of identifying the current physical activity
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (StreamSubscription<dynamic> sub in _streamSub) sub.cancel();
    //cancel the timers
    _modelTimer?.cancel();
    _sw?.cancel();
    _recordSens?.cancel();
    _recordRoute?.cancel();
    super.dispose();
  }

  //get the result from the tflite model
  Future<void> _getResult() async {
    // String biking, downstairs, jogging, sitting, standing, upstairs, walking;
    String res;

    try {
      res = await platform.invokeMethod('classify');
      // _results = await platform.invokeListMethod('classify');
      // biking = "Biking: \t" + _results[0];
      // downstairs = "Downstairs: \t" + _results[1];
      // jogging = "Jogging: \t" + _results[2];
      // sitting = "Sitting: \t" + _results[3];
      // standing = "Standing: \t" + _results[4];
      // upstairs = "Upstairs: \t" + _results[5];
      // walking = "Walking: \t" + _results[6];
    } on PlatformException catch (e) {
      res = "\nFailed to get the result: '${e.message}'";
      // biking = "Failed to get the result: '${e.message}'";
      // downstairs = "Failed to get the result: '${e.message}'";
      // jogging = "Failed to get the result: '${e.message}'";
      // sitting = "Failed to get the result: '${e.message}'";
      // standing = "Failed to get the result: '${e.message}'";
      // upstairs = "Failed to get the result: '${e.message}'";
      // walking = "Failed to get the result: '${e.message}'";
    }

    setState(() {
      _result = res;
      _detectedActivities.add(_result);
      // _biking = biking;
      // _downstairs = downstairs;
      // _jogging = jogging;
      // _sitting = sitting;
      // _standing = standing;
      // _upstairs = upstairs;
      // _walking = walking;
    });
  }

  //Google api
  // Future<void> _getResults() async {
  //   String detectedActivity, detectedActivityStatus, detectedActivityTime;

  //   try {
  //     _results = await platform.invokeListMethod('getResults');
  //     if (_results.isNotEmpty) {
  //       detectedActivity = _results[0];
  //       detectedActivityStatus = _results[1];
  //       detectedActivityTime = _results[2];
  //     }
  //   } on PlatformException catch (err) {
  //     detectedActivity = "An error occurred: ${err.message}";
  //     detectedActivityStatus = "An error occurred: ${err.message}";
  //     detectedActivityTime = "An error occurred: ${err.message}";
  //   }

  //   setState(() {
  //     _detectedActivity = detectedActivity;
  //     _detectedActivityStatus = detectedActivityStatus;
  //     _detectedActivityTime = detectedActivityTime;
  //   });
  // }

  //accelerometer and gyroscope
  void setUpAccelerometerGyroscope() {
    _streamSub.add(accelerometerEvents.listen((AccelerometerEvent e) {
      setState(() => _accelVal = <double>[e.x, e.y, e.z]);
    }));

    _streamSub.add(gyroscopeEvents.listen((GyroscopeEvent e) {
      setState(() => _gyroVal = <double>[e.x, e.y, e.z]);
    }));

    _streamSub.add(userAccelerometerEvents.listen((UserAccelerometerEvent e) {
      calculateSpeed(e);
    }));
  }

  List<String> getAccelerometer() {
    return _accelVal?.map((double v) => v.toStringAsFixed(1))?.toList();
  }

  List<String> getGyroscope() {
    return _gyroVal?.map((double v) => v.toStringAsFixed(1))?.toList();
  }

  //speedometer
  void calculateSpeed(UserAccelerometerEvent e) {
    double speed = sqrt(pow(e.x, 2) + pow(e.y, 2) + pow(e.z, 2));

    _allSpeed.add(speed);

    //unchanged on current speed detected
    if ((speed - _currentSpeed).abs() <= 0) return;

    setState(() {
      _currentSpeed = speed; //update current speed
      if (_currentSpeed > _highestSpeed)
        _highestSpeed = _currentSpeed; //update highest speed detected
    });
  }

  //calculate distance (km) between two coordinates by using Haversine formula
  void calculateDistance(LatLng previousPoint, LatLng newPoint) {
    double degToRad = pi / 180; //convert degree to radian

    double tmp = 0.5 -
        cos(degToRad * (newPoint.latitude - previousPoint.latitude)) / 2 +
        cos(degToRad * previousPoint.latitude) *
            cos(degToRad * newPoint.latitude) *
            (1 -
                cos(degToRad *
                    (newPoint.longitude - previousPoint.longitude))) /
            2;

    setState(() =>
        _totalDistance += 2 * 6371 * asin(sqrt(tmp))); //6371 km = Earth radius
  }

  //pedometer
  void setUpPedometer() {
    _streamSub
        .add(Pedometer.stepCountStream.listen(stepsToday, onError: stepError));
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

  Future<void> awakeSwitch(bool enable) async {
    Wakelock.toggle(enable: enable);
  }

  //countdown timer (3 seconds) + tracking delay (2 seconds)
  void startCountdown() {
    setState(() {
      startPressed = true;
      print(readyCountdown);
    });

    _countdown = Timer.periodic(refresh, (timer) {
      if (mounted)
        setState(() {
          readyCountdown = counter.toString();
          if (counter > 0) {
            print(readyCountdown);
            counter--;
          } else {
            _countdown.cancel();
            //start the stopwatch, record sensors' data and route after 3 seconds
            startStopwatch();
            startRecordingSensors();
            startRecordingRoute();
            setState(() => tracking = true);
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) setState(() => {trackingDelay = false});
            });
          }
        });
    });
  }

  //stopwatch (workout duration)
  void runningWatch() {
    if (sw.isRunning) _sw = Timer(refresh, runningWatch);

    //if the width of string of hours/minutes/seconds is less than 2, then add "0" to its left
    //remainder of 60s = minutes
    if (mounted)
      setState(() {
        stopwatchTime = sw.elapsed.inHours.toString().padLeft(2, "0") +
            ":" +
            (sw.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
            ":" +
            (sw.elapsed.inSeconds % 60).toString().padLeft(2, "0");
      });
  }

  Future<void> startStopwatch() async {
    await awakeSwitch(true); //keep the screen awake while tracking
    print("Start to workout... ");
    sw.start();
    _sw =
        Timer(refresh, runningWatch); //runningWatch is invoked in every second
  }

  Future<void> stopStopwatch() async {
    await awakeSwitch(false); //disable screen awake
    _countdown
        ?.cancel(); //cancel countdown timer if user pressed "leave" while counting down
    sw.stop();
    //pressed "leave" button or no data of user route (since refresh time of recording route is 5 seconds)
    //early stopping
    if (_sw == null || _route.isEmpty)
      noRecordToSaveDialog(
          context); //notify user that the no record will be saved
    else {
      print("Duration of workout: " + stopwatchTime);

      List<int> countActivities = [0, 0, 0, 0]; //used when auto mode
      double sum = 0.0;
      for (double s in _allSpeed) sum += s; //sum of speed

      _averageSpeed = sum / _allSpeed.length;

      if (widget.workoutType == "Auto") {
        for (int i = 0; i < _detectedActivities.length; i++) {
          switch (_detectedActivities[i]) {
            // case "Running":
            //   countActivities[0] += 1;
            //   break;
            case "Standing":
              countActivities[0] += 1;
              break;
            case "Walking":
              countActivities[1] += 1;
              break;
            case "Walking Upstairs":
              countActivities[2] += 1;
              break;
            case "Walking Downstairs":
              countActivities[3] += 1;
              break;
            default:
              break;
          }
        }
      }

      Navigator.of(context).pushReplacementNamed('/workoutSummary',
          arguments: ScreenArguments(
            -1, //unused
            widget.workoutType,
            countActivities,
            _route,
            stopwatchTime,
            _totalDistance,
            rows,
            _steps,
            _averageSpeed,
            _highestSpeed,
          ));
    }
  }

  //record sensors' data (used for generating csv file)
  void startRecordingSensors() {
    print("Start recording sensors' data... ");

    setState(() {
      recording = true;

      User user = FirebaseAuth.instance.currentUser;
      row.add(user.uid);
      rows.add(row);
      row = []; //reset

      row.add("Timestamp");
      row.add("Ax");
      row.add("Ay");
      row.add("Az");
      row.add("Gx");
      row.add("Gy");
      row.add("Gz");
      row.add("Activity");

      rows.add(row); //header row
    });

    _recordSens = Timer.periodic(sensorUpdate, (timer) {
      row = []; //reset

      String timestamp =
          new DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      row.add(timestamp);

      List<String> accel = getAccelerometer();
      List<String> gyro = getGyroscope();

      //accelerometer (x, y, z)
      row.add(accel[0]);
      row.add(accel[1]);
      row.add(accel[2]);

      //gyroscope (x, y, z)
      row.add(gyro[0]);
      row.add(gyro[1]);
      row.add(gyro[2]);

      //activity
      if (widget.workoutType != "Auto")
        row.add(widget.workoutType); //manual input mode
      else
        row.add(_result); //auto tracking mode

      rows.add(row);
    });
  }

  //record route in every 5 seconds
  void startRecordingRoute() async {
    _recordRoute = Timer.periodic(routeUpdate, (timer) async {
      Position currentLocation = await geo.getCurrentLocation();
      LatLng current =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      if (_route.isEmpty) {
        previous = current;
        _route.add(current); //source
        print("Current Location on Map: $current");
      } else if (current != _route.last) {
        //TODO: explain why used "mounted"
        if (mounted)
          calculateDistance(previous, current); //update total distance
        _route.add(
            current); //if the user stands still, do not have to add the location again
        print("Current Location on Map: $current");
        previous = current; //replace previous point with current point
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //disable the system back button
      child: FutureProvider(
        initialData: null,
        create: (content) =>
            geo.getCurrentLocation(), //current location of the user
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Stack(
            children: <Widget>[
              SafeArea(
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
                    maxChildSize: widget.workoutType != "Auto" ? 0.50 : 0.45,
                    builder: (BuildContext context, scrollCon) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionWidth(10.0),
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
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(getProportionWidth(6.0)),
                          children: <Widget>[
                            SizedBox(height: getProportionWidth(6.0)),
                            Center(
                              child: Container(
                                height: getProportionWidth(6.0),
                                width: getProportionWidth(60.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[200],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            SizedBox(height: getProportionWidth(10.0)),
                            SectionCard(
                              height: widget.workoutType != "Auto"
                                  ? getProportionWidth(320.0)
                                  : getProportionWidth(285.0),
                              title: "Workout Details",
                              topRightButton: SizedBox(width: 0.0),
                              content:
                                Container(
                                  height: widget.workoutType != "Auto" ? getProportionWidth(240.0) : getProportionWidth(205.0),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                readyCountdown == "0"
                                                    ? stopwatchTime
                                                    : readyCountdown,
                                                style: TextStyle(
                                                  fontSize:
                                                      readyCountdown == "0"
                                                          ? getProportionWidth(25.0)
                                                          : getProportionWidth(22.0),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: getProportionWidth(12.0)),
                                          startPressed
                                              ? SizedBox(width: 0.0)
                                              : ElevatedButton(
                                                  onPressed: startPressed
                                                      ? () {}
                                                      : startCountdown,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    //button background color
                                                    primary: startPressed
                                                        ? kDisabled
                                                        : kOkOrStart,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: getProportionWidth(8.0),
                                                            vertical: getProportionWidth(8.0)),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                  ),
                                                  child: Text(
                                                    "Start".toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: getProportionWidth(18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(width: getProportionWidth(5.0)),
                                          recording
                                              ?
                                              //stop button
                                              ElevatedButton(
                                                  onPressed:
                                                      () {}, //will not end the workout if just tap
                                                  onLongPress: stopStopwatch,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    //button background color
                                                    primary: kStopOrAutoBtn,
                                                    // : kReturn,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: getProportionWidth(8.0),
                                                            vertical: getProportionWidth(8.0)),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                  ),
                                                  child: Text(
                                                    "Long Press to Stop"
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: getProportionWidth(12.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  onPressed:
                                                      stopStopwatch, //in stopStopwatch function, return home page
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: kReturn,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: getProportionWidth(8.0),
                                                            vertical: getProportionWidth(8.0)),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                  ),
                                                  child: Text(
                                                    "Leave".toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: getProportionWidth(18.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),

                                      //TODO: classifying the type of physical activities
                                      SizedBox(height: getProportionWidth(18.0)),
                                      tracking
                                          ? TyperAnimatedTextKit(
                                              text: [
                                                "Tracking ...",
                                              ],
                                              textStyle: TextStyle(
                                                fontSize: getProportionWidth(18.0),
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.start,
                                            )
                                          : SizedBox(height: 0.0),

                                      trackingDelay
                                          ? SizedBox(height: 0.0)
                                          : Column(
                                              children: [
                                                SizedBox(height: getProportionWidth(10.0)),
                                                widget.workoutType != "Auto"
                                                    ? DetailRow(
                                                        title: 'Workout Type :',
                                                        content:
                                                            widget.workoutType)
                                                    : DetailRow(
                                                        title:
                                                            'Activity Detected :',
                                                        content: _result),
                                                SizedBox(height: getProportionWidth(10.0)),
                                                DetailRow(
                                                    title: 'Total Distance :',
                                                    content: _totalDistance
                                                            .toStringAsFixed(
                                                                1) +
                                                        " km"),
                                                SizedBox(height: getProportionWidth(10.0)),
                                                DetailRow(
                                                    title: 'Current Speed :',
                                                    content: _currentSpeed
                                                            .toStringAsFixed(
                                                                1) +
                                                        " m/s\u00B2"),
                                                (widget.workoutType ==
                                                            "Walking" ||
                                                        widget.workoutType ==
                                                            "Walking Upstairs" ||
                                                        widget.workoutType ==
                                                            "Walking Downstairs" ||
                                                        widget.workoutType ==
                                                            "Running")
                                                    ? Column(
                                                        children: <Widget>[
                                                          SizedBox(height: getProportionWidth(10.0)),
                                                          DetailRow(
                                                              title:
                                                                  'Steps Taken Today :',
                                                              content: _steps +
                                                                  " steps"),
                                                          SizedBox(height: getProportionWidth(10.0)),
                                                        ],
                                                      )
                                                    : SizedBox(height: getProportionWidth(10.0)),
                                              ],
                                            ),

                                      // SizedBox(height: 10.0),
                                      // Text(_biking),
                                      // SizedBox(height: 10.0),
                                      // Text(_downstairs),
                                      // SizedBox(height: 10.0),
                                      // Text(_jogging),
                                      // SizedBox(height: 10.0),
                                      // Text(_sitting),
                                      // SizedBox(height: 10.0),
                                      // Text(_standing),
                                      // SizedBox(height: 10.0),
                                      // Text(_upstairs),
                                      // SizedBox(height: 10.0),
                                      // Text(_walking),
                                      // SizedBox(height: 10.0),

                                      //google api
                                      // SizedBox(height: 20.0),
                                      // _results.isEmpty
                                      //     ? Text(
                                      //         "Tracking...",
                                      //         style: Theme.of(context)
                                      //             .textTheme
                                      //             .bodyText2
                                      //             .copyWith(
                                      //               fontSize: 20.0,
                                      //             ),
                                      //       )
                                      //     : Text(
                                      //         "Detected: \t" +
                                      //             _detectedActivity +
                                      //             "\t" +
                                      //             _detectedActivityStatus +
                                      //             "\t" +
                                      //             _detectedActivityTime,
                                      //         style: Theme.of(context)
                                      //             .textTheme
                                      //             .bodyText2
                                      //             .copyWith(
                                      //               fontSize: 20.0,
                                      //             ),
                                      //       ),
                                    ],
                              ),
                                ),
                            ),
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
