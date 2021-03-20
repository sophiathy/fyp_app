import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/detailRow.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:fyp_app/widgets/typeIndicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class ReviewRecord extends StatefulWidget {
  final int recordIndex;
  final String workoutType;
  final List<int> countActivities;
  final List<LatLng> route;
  final String duration;
  final double totalDistance;
  final List<List<String>> csvRows;
  final String todaySteps;
  final double averageSpeed;
  final double highestSpeed;

  const ReviewRecord({
    Key key,
    @required this.recordIndex,
    this.workoutType,
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
  _ReviewRecordState createState() => _ReviewRecordState();
}

class _ReviewRecordState extends State<ReviewRecord> {
  final geo = GeoService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  int tappedIndex; //tapped index of pie chart (auto mode)

  Box<List<dynamic>> recentRecordsBox =
      Hive.box('recentRecords'); //store 5 recently saved records
  List<dynamic> record;

  @override
  void initState() {
    super.initState();
    setState(() => record = recentRecordsBox.getAt(widget.recordIndex));
  }

  //pie chart showing the detected activities (auto mode)
  List<PieChartSectionData> displayActivities() {
    //0: Running, 1: Standing, 2: Walking, 3: Walking Upstairs, 4: Walking Downstairs
    double sumOfCount = 0.0;
    for (int i = 0; i < record.elementAt(2).length; i++)
      sumOfCount += record.elementAt(2).elementAt(i).toDouble();

    return List.generate(record.elementAt(2).length, (type) {
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
        //     title: record.elementAt(2).elementAt(type) > 0
        //         ? '${(record.elementAt(2).elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
        //         : "",
        //     titleStyle: TextStyle(
        //         color: Colors.white,
        //         fontSize: titleSize,
        //         fontWeight: FontWeight.bold),
        //     value: record.elementAt(2).elementAt(type).toDouble() /
        //         sumOfCount *
        //         360,
        //     radius: radius,
        //   );
        case 0:
          return PieChartSectionData(
            color: kStanding.withOpacity(opacity), //Standing
            title: record.elementAt(2).elementAt(type) > 0
                ? '${(record.elementAt(2).elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: record.elementAt(2).elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: kWalking.withOpacity(opacity), //Walking
            title: record.elementAt(2).elementAt(type) > 0
                ? '${(record.elementAt(2).elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: record.elementAt(2).elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 2:
          return PieChartSectionData(
            color: kUpstairs.withOpacity(opacity), //Walking upstairs
            title: record.elementAt(2).elementAt(type) > 0
                ? '${(record.elementAt(2).elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: record.elementAt(2).elementAt(type).toDouble() /
                sumOfCount *
                360,
            radius: radius,
          );
        case 3:
          return PieChartSectionData(
            color: kDownstairs.withOpacity(opacity), //Walking downstairs
            title: record.elementAt(2).elementAt(type) > 0
                ? '${(record.elementAt(2).elementAt(type).toDouble() / sumOfCount * 100).toStringAsFixed(1)} %'
                : "",
            titleStyle: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                fontWeight: FontWeight.bold),
            value: record.elementAt(2).elementAt(type).toDouble() /
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
        // body: Stack(
        //   children: <Widget>[
        //     SafeArea(
        //       top: true,
        //       left: true,
        //       right: true,
        //       child: Align(
        //           alignment: Alignment.center,
        //           // child: FinalMap(record.route),
        //           child: Text("Testing")),
        //     ),
        body: SafeArea(
          child: SizedBox.expand(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionWidth(16.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SectionCard(
                    height: record.elementAt(1) == "Auto"
                        ? getProportionHeight(420.0)
                        : getProportionHeight(330.0),
                    title:
                        "Workout Review\n(Saved at ${record.elementAt(0)})",
                    topRightButton: SizedBox(width: 0.0),
                    content:
                      //workout review
                      Container(
                        height: record.elementAt(1) == "Auto"
                        ? getProportionWidth(360.0) : getProportionWidth(250.0),
                        width: double.infinity,
                        child: Column(
                        children: <Widget>[
                          record.elementAt(1) != "Auto"
                              ? DetailRow(
                                  title: 'Workout Type :',
                                  content: record.elementAt(1))
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
                                            // record.elementAt(2).elementAt(0) > 0
                                            //     ? TypeIndicator(
                                            //         type: "Running",
                                            //         color: tappedIndex ==
                                            //                 3
                                            //             ? kRunning
                                            //             : kRunning
                                            //                 .withOpacity(
                                            //                     0.5),
                                            //         textColor: tappedIndex ==
                                            //                 3
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

                                            record.elementAt(2).elementAt(0) > 0
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

                                            record.elementAt(2).elementAt(1) > 0
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

                                            record.elementAt(2).elementAt(2) > 0
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

                                            record.elementAt(2).elementAt(3) > 0
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
                              content: record.elementAt(3)),
                          SizedBox(height: getProportionWidth(10.0)),
                          DetailRow(
                              title: 'Total Distance :',
                              content: record.elementAt(4)
                                      .toStringAsFixed(1) +
                                  " km"),
                          SizedBox(height: getProportionWidth(10.0)),
                          DetailRow(
                              title: 'Average Speed :',
                              content:
                                  "${record.elementAt(5).toStringAsFixed(1)} m/s\u00B2"),
                          SizedBox(height: getProportionWidth(10.0)),
                          DetailRow(
                              title: 'Highest Speed :',
                              content:
                                  "${record.elementAt(6).toStringAsFixed(1)} m/s\u00B2"),
                          SizedBox(height: getProportionWidth(10.0)),
                        ],
                    ),
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: getProportionWidth(40.0)),
                    child: Buttons(
                      name: "Return to Home",
                      press: (() => Navigator.of(context)
                          .pushReplacementNamed('/home')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
