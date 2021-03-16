// import 'dart:io';

import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/detailRow.dart';
import 'package:fyp_app/widgets/finalMap.dart';
import 'package:fyp_app/widgets/savedRecordDialog.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:fyp_app/widgets/typeIndicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

class WorkoutSummary extends StatefulWidget {
  final String workoutType;
  final List<int> countActivities;
  final List<LatLng> route;
  final String duration;
  final double totalDistance;
  final List<List<String>> csvRows;
  final String todaySteps;
  final double averageSpeed;
  final double highestSpeed;

  const WorkoutSummary({
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
  _WorkoutSummaryState createState() => _WorkoutSummaryState();
}

class _WorkoutSummaryState extends State<WorkoutSummary> {
  final geo = GeoService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  int tappedIndex; //tapped index of pie chart (auto mode)
  Box<int> workoutDurationBox =
      Hive.box('workoutDuration'); //store last saved workout seconds
  Box<double> workoutDistanceBox =
      Hive.box('workoutDistance'); //store last saved workout distance

  @override
  void initState() {
    super.initState();
    if (mounted) {
      outputCSV(); //workout duration exists => can directly output the sensors' data csv

      Future.delayed(
          Duration.zero,
          () => savedRecordDialog(
              context)); //notify user that the record has been saved

      workoutSummaryToday(
          widget.duration,
          widget
              .totalDistance); //calculate the sum of workout seconds and distance today
    }
  }

  void outputCSV() {
    final User user = auth.currentUser;
    final String uid = user.uid;

    String filename =
        "${uid}_${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}_" +
            "${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}_" +
            "${widget.workoutType}.csv";

    //convert list elements into csv string format
    String csv = const ListToCsvConverter().convert(widget.csvRows);

    uploadCsvFirebase(uid, filename, csv);

    //first attempt: create csv in local storage then upload it to Firebase
    // if (await Permission.storage.request().isGranted) {
    //   final storagePath = await getExternalStorageDirectory();
    //   storagePath.exists().then((isExists) {
    //     File outputFile = new File("${storagePath.path}/$filename");

    //     //write the csv string into the output file
    //     outputFile.writeAsString(csv);
    //     print(
    //         "Successfully saved data into " + "${storagePath.path}/$filename");

    //     //upload to Firebase Storage
    //     uploadCsvFirebase(uid, filename, csv);
    //   });
    // }
  }

  Future<void> uploadCsvFirebase(
      String uid, String filename, String csv) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      //get the file
      // File csvFile = File("${storagePath.path}/$filename");

      //points to the specified storage bucket
      Reference ref = storage.ref().child("$uid/$filename");

      //upload local file to Firebase
      // await ref.putFile(csvFile);

      //upload csv string to Firebase's csv file (newly created)
      await ref.putString(csv, format: PutStringFormat.raw);
      print("Successfully upload to Firebase!");
    } catch (e) {
      print("Could not upload the data/file to Firebase!");
    }
  }

  //update values to be shown in Today's Summary (Home page)
  workoutSummaryToday(String workoutDuration, double workoutDistance) {
    int h = int.parse(workoutDuration.substring(0, 2));
    int m = int.parse(workoutDuration.substring(3, 5));
    int s = int.parse(workoutDuration.substring(6));

    int totalSeconds = (h * 60 + m) * 60 + s;

    int lastSavedYearKey = 40;
    int lastSavedMonthKey = 41;
    int lastSavedDayKey = 42;

    int todayYear = DateTime.now().year;
    int todayMonth = DateTime.now().month;
    int todayDay = DateTime.now().day; //1-31 = key in hive

    //timestamp stored in workoutDurationBox (no need to store duplicated timestamp to workoutDistanceBox)
    int lastSavedYear =
        workoutDurationBox.get(lastSavedYearKey, defaultValue: 0);
    int lastSavedMonth =
        workoutDurationBox.get(lastSavedMonthKey, defaultValue: 0);
    int lastSavedDay = workoutDurationBox.get(lastSavedDayKey,
        defaultValue:
            0); //if does not exist in workoutDurationBox, its value = 0

    if (lastSavedYear < todayYear ||
        lastSavedMonth < todayMonth ||
        lastSavedDay < todayDay) {
      //reset to 0 if last saved is not today (one of the location 1-31 in hive)
      workoutDurationBox.put(lastSavedDay, 0);
      workoutDistanceBox.put(lastSavedDay, 0);

      lastSavedYear = todayYear;
      lastSavedMonth = todayMonth;
      lastSavedDay = todayDay;

      //update last saved timestamp to today
      workoutDurationBox.put(lastSavedYearKey, lastSavedYear);
      workoutDurationBox.put(lastSavedMonthKey, lastSavedMonth);
      workoutDurationBox.put(lastSavedDayKey, lastSavedDay);
    }
    //last saved date is today
    //store the sum of seconds today
    int sumDuration =
        workoutDurationBox.get(todayDay, defaultValue: 0) + totalSeconds;

    //store the sum of distance today
    double sumDistance =
        workoutDistanceBox.get(todayDay, defaultValue: 0) + workoutDistance;

    workoutDurationBox.put(
        todayDay, sumDuration); //update total workout seconds today
    workoutDistanceBox.put(
        todayDay, sumDistance); //update total workout distance (in km) today
  }

  //pie chart showing the detected activities (auto mode)
  List<PieChartSectionData> displayActivities() {
    //TODO: 0: Walking, 1: Upstairs, 2: Downstairs, 3: Jogging, 4: Biking, 5: Standing, 6: Sitting
    double sumOfCount = 0.0;
    for (int i = 0; i < widget.countActivities.length; i++)
      sumOfCount += widget.countActivities.elementAt(i).toDouble();

    return List.generate(widget.countActivities.length, (type) {
      bool isTapped = type == tappedIndex;
      double opacity = isTapped
          ? 1
          : 0.5; //if tapped, the type name will be highlighted in indicator

      double titleSize = isTapped ? 22.0 : 14.0;
      double radius = isTapped ? 70.0 : 60.0;

      switch (type) {
        case 0:
          return PieChartSectionData(
            color: kWalking.withOpacity(opacity), //Walking
            title: widget.countActivities.elementAt(type) > 0
                ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: widget.countActivities.elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: kUpstairs.withOpacity(opacity), //Walking upstairs
            title: widget.countActivities.elementAt(type) > 0
                ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: widget.countActivities.elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 2:
          return PieChartSectionData(
            color: kDownstairs.withOpacity(opacity), //Walking downstairs
            title: widget.countActivities.elementAt(type) > 0
                ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: widget.countActivities.elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 3:
          return PieChartSectionData(
            color: kRunning.withOpacity(opacity), //Running
            title: widget.countActivities.elementAt(type) > 0
                ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: widget.countActivities.elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 4:
          return PieChartSectionData(
            color: kCycling.withOpacity(opacity), //Cycling
            title: widget.countActivities.elementAt(type) > 0
                ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: widget.countActivities.elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 5:
          return PieChartSectionData(
            color: kStanding.withOpacity(opacity), //Standing
            title: widget.countActivities.elementAt(type) > 0
                ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: widget.countActivities.elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 6:
          return PieChartSectionData(
            color: kSitting.withOpacity(opacity), //Sitting
            title: widget.countActivities.elementAt(type) > 0
                ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: widget.countActivities.elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        default:
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false, //disable the system back button
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
                child: FinalMap(widget.route),
              ),
            ),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                  initialChildSize: widget.workoutType == "Auto" ? 0.42 : 0.35,
                  minChildSize: 0.15,
                  maxChildSize: widget.workoutType == "Auto" ? 0.70 : 0.55,
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
                                color: Colors.blueGrey[300],
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          Stack(
                            children: <Widget>[
                              SectionCard(
                                height: widget.workoutType == "Auto"
                                    ? 470.0
                                    : 330.0,
                                title: "Workout Summary",
                              ),

                              //workout summary
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 70.0, left: 24.0, right: 24.0),
                                child: Column(
                                  children: <Widget>[
                                    widget.workoutType != "Auto"
                                        ? DetailRow(
                                            title: 'Workout Type :',
                                            content: widget.workoutType)
                                        : Column(
                                            children: <Widget>[
                                              DetailRow(
                                                  title:
                                                      'Detected Workout Type(s) :',
                                                  content: ""),
                                              SizedBox(height: 10.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Spacer(),
                                                  Container(
                                                    height: 180.0,
                                                    width: 180.0,
                                                    child: PieChart(
                                                      PieChartData(
                                                          pieTouchData:
                                                              PieTouchData(
                                                                  touchCallback:
                                                                      (tapped) {
                                                            setState(() {
                                                              if (tapped.touchInput
                                                                      is FlLongPressEnd ||
                                                                  tapped.touchInput
                                                                      is FlPanEnd) //long press end or drag end
                                                                tappedIndex =
                                                                    -1; //reset index
                                                              else
                                                                tappedIndex = tapped
                                                                    .touchedSectionIndex; //save newly tapped section
                                                            });
                                                          }),
                                                          borderData: FlBorderData(
                                                              show:
                                                                  false), //remove outer border
                                                          centerSpaceRadius:
                                                              20.0,
                                                          sectionsSpace:
                                                              2, //spaces between sections
                                                          sections:
                                                              displayActivities()),
                                                    ),
                                                  ),
                                                  SizedBox(width: 30.0),
                                                  //detected workout type indicator
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      widget.countActivities[
                                                                  0] >
                                                              0
                                                          ? TypeIndicator(
                                                              type: "Walking",
                                                              color: tappedIndex ==
                                                                      0
                                                                  ? kWalking
                                                                  : kWalking
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor: tappedIndex ==
                                                                      0
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            )
                                                          : SizedBox(
                                                              width: 0.0),
                                                      widget.countActivities[
                                                                  1] >
                                                              0
                                                          ? TypeIndicator(
                                                              type: "Upstairs",
                                                              color: tappedIndex ==
                                                                      1
                                                                  ? kUpstairs
                                                                  : kUpstairs
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor: tappedIndex ==
                                                                      1
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            )
                                                          : SizedBox(
                                                              width: 0.0),
                                                      widget.countActivities[
                                                                  2] >
                                                              0
                                                          ? TypeIndicator(
                                                              type:
                                                                  "Downstairs",
                                                              color: tappedIndex ==
                                                                      2
                                                                  ? kDownstairs
                                                                  : kDownstairs
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor: tappedIndex ==
                                                                      2
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            )
                                                          : SizedBox(
                                                              width: 0.0),
                                                      widget.countActivities[
                                                                  3] >
                                                              0
                                                          ? TypeIndicator(
                                                              type: "Running",
                                                              color: tappedIndex ==
                                                                      3
                                                                  ? kRunning
                                                                  : kRunning
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor: tappedIndex ==
                                                                      3
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            )
                                                          : SizedBox(
                                                              width: 0.0),
                                                      widget.countActivities[
                                                                  4] >
                                                              0
                                                          ? TypeIndicator(
                                                              type: "Cycling",
                                                              color: tappedIndex ==
                                                                      4
                                                                  ? kCycling
                                                                  : kCycling
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor: tappedIndex ==
                                                                      4
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            )
                                                          : SizedBox(
                                                              width: 0.0),
                                                      widget.countActivities[
                                                                  5] >
                                                              0
                                                          ? TypeIndicator(
                                                              type: "Standing",
                                                              color: tappedIndex ==
                                                                      5
                                                                  ? kStanding
                                                                  : kStanding
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor: tappedIndex ==
                                                                      5
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            )
                                                          : SizedBox(
                                                              width: 0.0),
                                                      widget.countActivities[
                                                                  6] >
                                                              0
                                                          ? TypeIndicator(
                                                              type: "Sitting",
                                                              color: tappedIndex ==
                                                                      6
                                                                  ? kSitting
                                                                  : kSitting
                                                                      .withOpacity(
                                                                          0.5),
                                                              textColor: tappedIndex ==
                                                                      6
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5),
                                                            )
                                                          : SizedBox(
                                                              width: 0.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    SizedBox(height: 10.0),
                                    DetailRow(
                                        title: 'Duration :',
                                        content: widget.duration),
                                    SizedBox(height: 10.0),
                                    DetailRow(
                                        title: 'Total Distance :',
                                        content: widget.totalDistance
                                                .toStringAsFixed(1) +
                                            " km"),
                                    SizedBox(height: 10.0),
                                    DetailRow(
                                        title: 'Average Speed :',
                                        content:
                                            "${widget.averageSpeed.toStringAsFixed(1)} m/s\u00B2"),
                                    SizedBox(height: 10.0),
                                    DetailRow(
                                        title: 'Highest Speed :',
                                        content:
                                            "${widget.highestSpeed.toStringAsFixed(1)} m/s\u00B2"),
                                    (widget.workoutType == "Walking" ||
                                            widget.workoutType ==
                                                "Walking Upstairs" ||
                                            widget.workoutType ==
                                                "Walking Downstairs" ||
                                            widget.workoutType == "Running")
                                        ? Column(
                                            children: <Widget>[
                                              SizedBox(height: 10.0),
                                              DetailRow(
                                                  title: 'Steps Taken Today :',
                                                  content:
                                                      "${widget.todaySteps} steps"),
                                              SizedBox(height: 10.0),
                                            ],
                                          )
                                        : SizedBox(height: 10.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 16.0, right: 16.0),
                            child: Buttons(
                              name: "Return to Home",
                              press: (() => Navigator.of(context)
                                  .pushReplacementNamed('/home')),
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
    );
  }
}
