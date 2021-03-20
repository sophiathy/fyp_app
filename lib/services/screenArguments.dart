import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenArguments {
  int recordIndex;
  String workoutType;
  List<int> countActivities;
  List<LatLng> route;
  String duration;
  double totalDistance;
  List<List<String>> csvRows;
  String todaySteps;
  double averageSpeed;
  double highestSpeed;

  ScreenArguments(
    this.recordIndex,
    this.workoutType,
    this.countActivities,
    this.route,
    this.duration,
    this.totalDistance,
    this.csvRows,
    this.todaySteps,
    this.averageSpeed,
    this.highestSpeed,
  );
}
