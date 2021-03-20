import 'package:flutter/material.dart';
import 'package:fyp_app/services/screenArguments.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/widgets/recordOptions.dart';
import 'package:fyp_app/widgets/sectionCard.dart';
import 'package:hive/hive.dart';

class RecordsSection extends StatefulWidget {
  final bool modeSwitch;

  const RecordsSection({Key key, this.modeSwitch}) : super(key: key);

  @override
  _RecordsSectionState createState() => _RecordsSectionState();
}

class _RecordsSectionState extends State<RecordsSection> {
  Box<int> settingsBox =
      Hive.box('settings'); //key 10: store lastSavedRecordIndex
  int lastSavedRecordIndexKey = 10;

  Box<List<dynamic>> recentRecordsBox =
      Hive.box('recentRecords'); //store 5 recently saved records

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      height: getProportionHeight(285.0),
      title: "Recent Records",
      topRightButton: SizedBox(width: 0.0),
      content:
        Container(
          height: getProportionWidth(260.0),
          child: Row(
            mainAxisAlignment:
                settingsBox.get(lastSavedRecordIndexKey, defaultValue: -1) ==
                        -1
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: <Widget>[
              settingsBox.get(lastSavedRecordIndexKey, defaultValue: -1) == -1
                  ? Text(
                      "No Workout Records",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: getProportionWidth(18.0),
                            fontWeight: FontWeight.w500,
                          ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(getProportionWidth(15.0)),
                      child: Container(
                        width: getProportionWidth(278.0),
                        height: getProportionHeight(210.0),
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            recentRecordsBox.get(4) != null
                                ? RecordOptions(
                                    index: 4,
                                    timestamp:
                                        recentRecordsBox.get(4).elementAt(0),
                                    type: recentRecordsBox.get(4).elementAt(1),
                                    tap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              '/reviewRecord',
                                              arguments: ScreenArguments(
                                                  4,
                                                  "N/A",
                                                  [],
                                                  [],
                                                  "00:00:00",
                                                  0.0,
                                                  [],
                                                  "0",
                                                  0.0,
                                                  0.0));
                                    },
                                  )
                                : SizedBox(width: 0.0),
                            recentRecordsBox.get(3) != null
                                ? RecordOptions(
                                    index: 3,
                                    timestamp:
                                        recentRecordsBox.get(3).elementAt(0),
                                    type: recentRecordsBox.get(3).elementAt(1),
                                    tap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              '/reviewRecord',
                                              arguments: ScreenArguments(
                                                  3,
                                                  "N/A",
                                                  [],
                                                  [],
                                                  "00:00:00",
                                                  0.0,
                                                  [],
                                                  "0",
                                                  0.0,
                                                  0.0));
                                    },
                                  )
                                : SizedBox(width: 0.0),
                            recentRecordsBox.get(2) != null
                                ? RecordOptions(
                                    index: 2,
                                    timestamp:
                                        recentRecordsBox.get(2).elementAt(0),
                                    type: recentRecordsBox.get(2).elementAt(1),
                                    tap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              '/reviewRecord',
                                              arguments: ScreenArguments(
                                                  2,
                                                  "N/A",
                                                  [],
                                                  [],
                                                  "00:00:00",
                                                  0.0,
                                                  [],
                                                  "0",
                                                  0.0,
                                                  0.0));
                                    },
                                  )
                                : SizedBox(width: 0.0),
                            recentRecordsBox.get(1) != null
                                ? RecordOptions(
                                    index: 1,
                                    timestamp:
                                        recentRecordsBox.get(1).elementAt(0),
                                    type: recentRecordsBox.get(1).elementAt(1),
                                    tap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              '/reviewRecord',
                                              arguments: ScreenArguments(
                                                  1,
                                                  "N/A",
                                                  [],
                                                  [],
                                                  "00:00:00",
                                                  0.0,
                                                  [],
                                                  "0",
                                                  0.0,
                                                  0.0));
                                    },
                                  )
                                : SizedBox(width: 0.0),
                            recentRecordsBox.get(0) != null
                                ? RecordOptions(
                                    index: 0,
                                    timestamp:
                                        recentRecordsBox.get(0).elementAt(0),
                                    type: recentRecordsBox.get(0).elementAt(1),
                                    tap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              '/reviewRecord',
                                              arguments: ScreenArguments(
                                                  0,
                                                  "N/A",
                                                  [],
                                                  [],
                                                  "00:00:00",
                                                  0.0,
                                                  [],
                                                  "0",
                                                  0.0,
                                                  0.0));
                                    },
                                  )
                                : SizedBox(width: 0.0),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
    );
  }
}
