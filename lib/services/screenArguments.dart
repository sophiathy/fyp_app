import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenArguments {
  String workoutType;
  List<LatLng> route;
  String duration;
  List<List<String>> csvRows;
  String todaySteps;
  double averageSpeed;
  double highestSpeed;

  ScreenArguments(
    this.workoutType,
    this.route,
    this.duration,
    this.csvRows,
    this.todaySteps,
    this.averageSpeed,
    this.highestSpeed,
  );
}
