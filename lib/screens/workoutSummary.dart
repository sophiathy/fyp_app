// import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/buttons.dart';
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

  const WorkoutSummary({
    Key key,
    @required this.workoutType,
    this.duration,
    this.csvRows,
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

  savedRecordDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        headerAnimationLoop: false,
        body: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            Text(
              'Well Done!',
              style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(
                  fontSize: 20.0,
                ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Your workout record has been saved.',
              style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(
                  fontSize: 16.0,
                ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
        btnOkOnPress: () {
          debugPrint('User pressed OK');
        },
        btnOkIcon: Icons.check_circle,
        btnOkText: 'Nice',
        onDissmissCallback: () {
          debugPrint('Dialog Dismiss...');
        },
      )..show();
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
                    vertical: 30.0, horizontal: 16.0),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Workout Type :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                              Text(
                                '${widget.workoutType}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Duration :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                              Text(
                                '${widget.duration}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total Distance :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                              Text(
                                '100 m',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 20.0,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          if (widget.workoutType == "Walking" ||
                              widget.workoutType == "Running")
                            Text('Steps taken: 100 steps'),
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
