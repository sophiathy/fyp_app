import 'package:flutter/material.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:fyp_app/widgets/sectionCard.dart';

class SummarySection extends StatelessWidget {
  final bool modeSwitch;

  const SummarySection({
    Key key,
    @required this.modeSwitch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SectionCard(
          height: 250.0,
          title: "Today's Summary",
        ),

        Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 24.0, right: 24.0),
          child: Container(
            height: 150.0,
            child: Row(
              children: <Widget>[
                SizedBox(width: 10.0),

                //graph
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    child: Icon(
                      Icons.bar_chart,
                      color: Colors.green,
                      size: 100.0,
                    ),
                  ),
                ),

                SizedBox(width: 20.0),

                //workout minutes & burned calories
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: modeSwitch? kIconBg_dark : kIconBg_light,
                              ),
                              child: Icon(
                                Icons.timer,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "70",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Workout\nMinutes".toUpperCase(),
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: modeSwitch? kIconBg_dark : kIconBg_light,
                              ),
                              child: Icon(
                                Icons.local_fire_department,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "834",
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Burned\nCalories".toUpperCase(),
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
