class ScreenArguments {
  String workoutType;
  String duration;
  List<List<String>> csvRows;
  String todaySteps;
  double highestSpeed;

  ScreenArguments(
    this.workoutType,
    this.duration,
    this.csvRows,
    this.todaySteps,
    this.highestSpeed,
  );
}
