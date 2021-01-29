import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/map.dart';
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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (mounted) _getResults();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
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

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //disable the system back button
      child: FutureProvider(
        create: (content) =>
            geo.getCurrentLocation(), //current location of the user
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SafeArea(
                top: true,
                left: true,
                right: true,
                child: Container(
                  width: double.infinity,
                  height: 400.0,
                  child:
                      Consumer<Position>(builder: (context, position, widget) {
                    return (position == null)
                        ? Center(child: CircularProgressIndicator())
                        : ShowMap(position); //TODO: comment
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 16.0),
                child: Stack(
                  children: <Widget>[
                    SectionCard(
                      height: 400.0,
                      title: "Workout Details (${widget.workoutType})",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 70.0, left: 24.0, right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SensorsInfo(workoutType: widget.workoutType),

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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Buttons(
                  name: "End",
                  press: (() => Navigator.of(context).pushReplacementNamed(
                      '/workoutSummary',
                      arguments: widget.workoutType)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
