import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors/sensors.dart';

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
  List<StreamSubscription<dynamic>> _streamSub = <StreamSubscription<dynamic>>[];
  List<double> _accelVal;
  List<double> _userAccelVal;
  List<double> _gyroVal;
  String _steps = "0";

  @override
  void initState() {
    super.initState();
    //stream subscriptions on Accelerometer and Gyroscope
    setUpAccelerometerGyroscope();
    //stream subscriptions on Pedometer
    setUpPedometer();
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> sub in _streamSub)
      sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> accelerometer = _accelVal?.map((double v) => v.toStringAsFixed(1))?.toList();

    final List<String> userAccelerometer = _userAccelVal?.map((double v) => v.toStringAsFixed(1))?.toList();

    final List<String> gyroscope = _gyroVal?.map((double v) => v.toStringAsFixed(1))?.toList();

    return Stack(
      children: <Widget>[
        SectionCard(
          height: 220.0,
          title: "Workout Details (${widget.workoutType})",
        ),

        //sensors information
        Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text('Accelerometer: $accelerometer'),

              SizedBox(height: 10.0),

              Text('UserAccelerometer: $userAccelerometer'),

              SizedBox(height: 10.0),

              Text('Gyroscope: $gyroscope'),

              SizedBox(height: 10.0),

              if(widget.workoutType == "Walking" || widget.workoutType == "Running")
                Text('Steps taken: $_steps'),

            ],
          ),
        ),
      ],
    );
  }

  void setUpAccelerometerGyroscope(){
    _streamSub.add(accelerometerEvents.listen((AccelerometerEvent e){
      setState(() => _accelVal = <double>[e.x, e.y, e.z]);
    }));

    _streamSub.add(userAccelerometerEvents.listen((UserAccelerometerEvent e){
      setState(() => _userAccelVal = <double>[e.x, e.y, e.z]);
    }));

    _streamSub.add(gyroscopeEvents.listen((GyroscopeEvent e){
      setState(() => _gyroVal = <double>[e.x, e.y, e.z]);
    }));
  }

  void stepCount(StepCount e) => setState(() => _steps = e.steps.toString());

  void stepError(error){
    setState((){
      print("Cannot count steps: $error");
      _steps = "Not available for counting steps.";
    });
  }

  void setUpPedometer(){
    _streamSub.add(Pedometer.stepCountStream.listen(stepCount, onError: stepError));
  }
}