class ScreenArguments {
  String workoutType;
  String duration;
  List<List<String>> csvRows;
  String todaySteps;

  ScreenArguments(
    this.workoutType,
    this.duration,
    this.csvRows,
    this.todaySteps,
  );
}
