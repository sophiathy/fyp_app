// import 'dart:io';

import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/detailRow.dart';
import 'package:fyp_app/widgets/savedRecordDialog.dart';
import 'package:fyp_app/widgets/showMap.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class WorkoutSummary extends StatefulWidget {
  final String workoutType;
  final String duration;
  final List<List<String>> csvRows;
  final String todaySteps;

  const WorkoutSummary({
    Key key,
    @required this.workoutType,
    this.duration,
    this.csvRows,
    this.todaySteps,
  }) : super(key: key);

  @override
  _WorkoutSummaryState createState() => _WorkoutSummaryState();
}

class _WorkoutSummaryState extends State<WorkoutSummary> {
  final geo = GeoService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    outputCSV(); //workout duration exists => can directly output the sensors' data csv
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

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration.zero,
        () => savedRecordDialog(
            context)); //notify user that the record has been saved
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
                    vertical: 20.0, horizontal: 16.0),
                child: Stack(
                  children: <Widget>[
                    SectionCard(
                      height: 280.0,
                      title: "Workout Summary",
                    ),

                    //workout summary
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 70.0, left: 24.0, right: 24.0),
                      child: Column(
                        children: <Widget>[
                          DetailRow(
                              title: 'Workout Type :',
                              content: widget.workoutType),
                          SizedBox(height: 10.0),
                          DetailRow(
                              title: 'Duration :', content: widget.duration),
                          SizedBox(height: 10.0),
                          DetailRow(
                              title: 'Total Distance :', content: "100 m"),
                          (widget.workoutType == "Walking" ||
                                  widget.workoutType == "Running")
                              ? Column(
                                  children: <Widget>[
                                    SizedBox(height: 10.0),
                                    DetailRow(
                                        title: 'Total Steps Taken Today :',
                                        content: "${widget.todaySteps} steps"),
                                  ],
                                )
                              : SizedBox(height: 10.0),
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
                  name: "Return to Home",
                  press: (() =>
                      Navigator.of(context).pushReplacementNamed('/home')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
