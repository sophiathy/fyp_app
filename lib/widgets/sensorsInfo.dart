import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors/sensors.dart';

import 'package:permission_handler/permission_handler.dart';

class SensorsInfo extends StatefulWidget {
  final String workoutType;

  const SensorsInfo({
    Key key,
    @required this.workoutType,
  }) : super(key: key);

  @override
  _SensorsInfoState createState() => _SensorsInfoState();
}

class _SensorsInfoState extends State<SensorsInfo> {
  List<StreamSubscription<dynamic>> _streamSub =
      <StreamSubscription<dynamic>>[];
  List<double> _accelVal;
  List<double> _gyroVal;
  String _steps;

  @override
  void initState() {
    super.initState();
    //stream subscriptions on Accelerometer and Gyroscope
    setUpAccelerometerGyroscope();
    //stream subscriptions on Pedometer
    setUpPedometer();
    checkPermissionActivity();
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> sub in _streamSub) sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer =
        _accelVal?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope =
        _gyroVal?.map((double v) => v.toStringAsFixed(1))?.toList();

    //sensors information
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Accelerometer: $accelerometer'),
        SizedBox(height: 10.0),
        Text('Gyroscope: $gyroscope'),
        SizedBox(height: 10.0),
        if (widget.workoutType == "Walking" ||
            widget.workoutType == "Running")
          Text('Steps taken: $_steps'),
      ],
    );
  }

  void setUpAccelerometerGyroscope() {
    _streamSub.add(accelerometerEvents.listen((AccelerometerEvent e) {
      setState(() => _accelVal = <double>[e.x, e.y, e.z]);
    }));

    _streamSub.add(gyroscopeEvents.listen((GyroscopeEvent e) {
      setState(() => _gyroVal = <double>[e.x, e.y, e.z]);
    }));
  }

  void stepCount(StepCount e) => setState(() => _steps = e.steps.toString());

  void stepError(error) {
    setState(() {
      print("Cannot count steps: $error");
      _steps = "Not available for counting steps.";
    });
  }

  void setUpPedometer() {
    _streamSub
        .add(Pedometer.stepCountStream.listen(stepCount, onError: stepError));
    setState(() => _steps = "0"); //reset to zero at the beginning
  }

  checkPermissionActivity() async {
    var activityStatus = await Permission.activityRecognition.status;

    if (!activityStatus.isGranted)
      await Permission.activityRecognition.request();
  }
}
