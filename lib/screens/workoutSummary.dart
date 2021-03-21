// import 'dart:io';

import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/detailRow.dart';
import 'package:fyp_app/widgets/finalMap.dart';
import 'package:fyp_app/widgets/dialogs/savedRecordDialog.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:fyp_app/widgets/indicators/typeIndicator.dart';
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
  Box<int> todaysDurationBox =
      Hive.box('todaysDuration'); //store last saved today's workout seconds
  Box<double> todaysDistanceBox =
      Hive.box('todaysDistance'); //store last saved today's workout distance

  Box<int> settingsBox = Hive.box(
      'settings'); //key 10: store lastSavedRecordIndex, unlock "Auto" requirements(key 20-24)
  int lastSavedRecordIndexKey = 10;
  int unlockKey = 24;

  Box<List<dynamic>> recentRecordsBox =
      Hive.box('recentRecords'); //store 5 recently saved records

  @override
  void initState() {
    super.initState();
    if (mounted) {
      outputCSV(); //workout duration exists => can directly output the sensors' data csv

      //timestamp of saving the current record
      String timestamp =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day} " +
              "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";

      //initialize empty records to key 0-4 of recentRecordsBox
      if (recentRecordsBox.isEmpty)
        for (int i = 0; i <= 4; i++) recentRecordsBox.add(null);

      List<dynamic> record = [
        timestamp,
        widget.workoutType,
        widget.countActivities,
        widget.duration,
        //widget.route,
        widget.totalDistance,
        widget.averageSpeed,
        widget.highestSpeed,
      ];

      int lastSavedRecordIndex =
          settingsBox.get(lastSavedRecordIndexKey, defaultValue: -1);

      print("Last index: $lastSavedRecordIndex");

      //update Recent Records in Home
      if (lastSavedRecordIndex + 1 <= 4) {
        //case: lastSavedRecordIndex = 0-3
        recentRecordsBox.put(lastSavedRecordIndex + 1, record);
        print("Put in new index: ${lastSavedRecordIndex + 1}");

        settingsBox.put(lastSavedRecordIndexKey,
            lastSavedRecordIndex + 1); //update last saved index
      } else {
        //case: always points to index 4
        for (int i = 1; i <= 4; i++) {
          recentRecordsBox.put(
              i - 1, recentRecordsBox.get(i)); //eg. move data in [1] to [0]
          if (i == 4)
            recentRecordsBox.put(i, record); //keep the latest in index [4]
        }
        print("Updated the order of records!");
      }

      //update unlock auto mode requirements (0=lock, 1=unlock, -1=unlocked already)
      if (settingsBox.get(unlockKey, defaultValue: 0) == 0) {
        int update = 0;

        if (widget.workoutType == "Walking")
          update = 20;
        else if (widget.workoutType == "Walking Upstairs")
          update = 21;
        else if (widget.workoutType == "Walking Downstairs")
          update = 22;
        else if (widget.workoutType == "Running") update = 23;

        if (settingsBox.get(update, defaultValue: 2) - 1 >= 0)
          settingsBox.put(update, settingsBox.get(update, defaultValue: 2) - 1);

        bool unlockAuto = false;

        //check if fulfill requirements (walking, upstairs, downstairs, running => all = 0)
        for (int i = 0; i < 4; i++) {
          if (settingsBox.get(20 + i, defaultValue: 2) == 0)
            unlockAuto = true;
          else {
            unlockAuto = false;
            break;
          }
        }

        //fulfill requirements
        if (unlockAuto)
          settingsBox.put(unlockKey, 1); //can unlock auto when return home page
      }

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
  workoutSummaryToday(String duration, double distance) {
    int h = int.parse(duration.substring(0, 2));
    int m = int.parse(duration.substring(3, 5));
    int s = int.parse(duration.substring(6));

    int totalSeconds = (h * 60 + m) * 60 + s;

    int lastSavedYearKey = 40;
    int lastSavedMonthKey = 41;
    int lastSavedDayKey = 42;

    int todayYear = DateTime.now().year;
    int todayMonth = DateTime.now().month;
    int todayDay = DateTime.now().day; //1-31 = key in hive

    //timestamp stored in todaysDurationBox (no need to store duplicated timestamp to todaysDistanceBox)
    int lastSavedYear =
        todaysDurationBox.get(lastSavedYearKey, defaultValue: 0);
    int lastSavedMonth =
        todaysDurationBox.get(lastSavedMonthKey, defaultValue: 0);
    int lastSavedDay = todaysDurationBox.get(lastSavedDayKey,
        defaultValue:
            0); //if does not exist in todaysDurationBox, its value = 0

    if (lastSavedYear < todayYear ||
        lastSavedMonth < todayMonth ||
        lastSavedDay < todayDay) {
      //reset to 0 if last saved is not today (one of the location 1-31 in hive)
      todaysDurationBox.put(lastSavedDay, 0);
      todaysDistanceBox.put(lastSavedDay, 0);

      lastSavedYear = todayYear;
      lastSavedMonth = todayMonth;
      lastSavedDay = todayDay;

      //update last saved timestamp to today
      todaysDurationBox.put(lastSavedYearKey, lastSavedYear);
      todaysDurationBox.put(lastSavedMonthKey, lastSavedMonth);
      todaysDurationBox.put(lastSavedDayKey, lastSavedDay);
    }
    //last saved date is today
    //sum of seconds today
    int sumDuration =
        todaysDurationBox.get(todayDay, defaultValue: 0) + totalSeconds;

    //sum of distance today
    double sumDistance =
        todaysDistanceBox.get(todayDay, defaultValue: 0) + distance;

    todaysDurationBox.put(
        todayDay, sumDuration); //update total workout seconds today
    todaysDistanceBox.put(
        todayDay, sumDistance); //update total workout distance (in km) today
  }

  //pie chart showing the detected activities (auto mode)
  List<PieChartSectionData> displayActivities() {
    //0: Running, 1: Standing, 2: Walking, 3: Walking Upstairs, 4: Walking Downstairs
    double sumOfCount = 0.0;
    for (int i = 0; i < widget.countActivities.length; i++)
      sumOfCount += widget.countActivities.elementAt(i).toDouble();

    return List.generate(widget.countActivities.length, (type) {
      bool isTapped = type == tappedIndex;
      double opacity = isTapped
          ? 1
          : 0.5; //if tapped, the type name will be highlighted in indicator

      double titleSize = isTapped ? getProportionWidth(20.0) : getProportionWidth(12.0);
      double radius = isTapped ? getProportionWidth(60.0) : getProportionWidth(50.0);

      switch (type) {
        // case 0:
        //   return PieChartSectionData(
        //     color: kRunning.withOpacity(opacity), //Running
        //     title: widget.countActivities.elementAt(type) > 0
        //         ? '${(widget.countActivities.elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
        //         : "",
        //     titleStyle: TextStyle(
        //         color: Colors.white,
        //         fontSize: titleSize,
        //         fontWeight: FontWeight.bold),
        //     value: widget.countActivities.elementAt(type).toDouble() /
        //         sumOfCount *
        //         360,
        //     radius: radius,
        //   );
        case 0:
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
        case 1:
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
        case 2:
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
        case 3:
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
              child: Align(
                alignment: Alignment.center,
                child: FinalMap(widget.route),
              ),
            ),
            SizedBox.expand(
              child: DraggableScrollableSheet(
                  initialChildSize: widget.workoutType == "Auto" ? 0.42 : 0.35,
                  minChildSize: 0.15,
                  maxChildSize: widget.workoutType == "Auto" ? 0.85 : 0.65,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0),
                        ),
                        child: ListView(
                          controller: scrollCon,
                          padding: EdgeInsets.all(getProportionWidth(6.0)),
                          shrinkWrap: true,
                          children: <Widget>[
                            SizedBox(height: getProportionWidth(6.0)),
                            Center(
                              child: Container(
                                height: getProportionWidth(6.0),
                                width: getProportionWidth(60.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[300],
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            SizedBox(height: getProportionWidth(10.0)),
                            SectionCard(
                              title: "Workout Summary",
                              topRightButton: SizedBox(width: 0.0),
                              content:
                                //workout summary
                                Column(
                                  children: <Widget>[
                                    widget.workoutType != "Auto"
                                        ? DetailRow(
                                            title: 'Workout Type :',
                                            content: widget.workoutType)
                                        : Column(
                                            children: <Widget>[
                                              DetailRow(
                                                  title:
                                                      'Distribution of Workout(s) :',
                                                  content: ""),
                                              SizedBox(height: getProportionWidth(10.0)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Spacer(),
                                                  Container(
                                                    height: getProportionWidth(160.0),
                                                    width: getProportionWidth(160.0),
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
                                                  SizedBox(width: getProportionWidth(30.0)),
                                                  //detected workout type indicator
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      // widget.countActivities[
                                                      //             0] >
                                                      //         0
                                                      //     ? TypeIndicator(
                                                      //         type: "Running",
                                                      //         color: tappedIndex ==
                                                      //                 0
                                                      //             ? kRunning
                                                      //             : kRunning
                                                      //                 .withOpacity(
                                                      //                     0.5),
                                                      //         textColor: tappedIndex ==
                                                      //                 0
                                                      //             ? Theme.of(
                                                      //                     context)
                                                      //                 .primaryColor
                                                      //             : Theme.of(
                                                      //                     context)
                                                      //                 .primaryColor
                                                      //                 .withOpacity(
                                                      //                     0.5),
                                                      //       )
                                                      //     : SizedBox(
                                                      //         width: 0.0),

                                                      widget.countActivities[
                                                                  0] >
                                                              0
                                                          ? TypeIndicator(
                                                              type: "Standing",
                                                              color: tappedIndex ==
                                                                      0
                                                                  ? kStanding
                                                                  : kStanding
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
                                                              type: "Walking",
                                                              color: tappedIndex ==
                                                                      1
                                                                  ? kWalking
                                                                  : kWalking
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
                                                              type: "Upstairs",
                                                              color: tappedIndex ==
                                                                      2
                                                                  ? kUpstairs
                                                                  : kUpstairs
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
                                                              type:
                                                                  "Downstairs",
                                                              color: tappedIndex ==
                                                                      3
                                                                  ? kDownstairs
                                                                  : kDownstairs
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
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    SizedBox(height: getProportionWidth(10.0)),
                                    DetailRow(
                                        title: 'Duration :',
                                        content: widget.duration),
                                    SizedBox(height: getProportionWidth(10.0)),
                                    DetailRow(
                                        title: 'Total Distance :',
                                        content: widget.totalDistance
                                                .toStringAsFixed(1) +
                                            " km"),
                                    SizedBox(height: getProportionWidth(10.0)),
                                    DetailRow(
                                        title: 'Average Speed :',
                                        content:
                                            "${widget.averageSpeed.toStringAsFixed(1)} m/s\u00B2"),
                                    SizedBox(height: getProportionWidth(10.0)),
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
                                              SizedBox(height: getProportionWidth(10.0)),
                                              DetailRow(
                                                  title: 'Steps Taken Today :',
                                                  content:
                                                      "${widget.todaySteps} steps"),
                                              SizedBox(height: getProportionWidth(10.0)),
                                            ],
                                          )
                                        : SizedBox(height: getProportionWidth(10.0)),
                                  ],
                                ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getProportionWidth(20.0)),
                              child: Buttons(
                                name: "Return to Home",
                                press: (() => Navigator.of(context)
                                    .pushReplacementNamed('/home')),
                              ),
                            ),
                          ],
                        ),
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
