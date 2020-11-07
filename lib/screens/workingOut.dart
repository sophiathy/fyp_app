import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/map.dart';
import 'package:fyp_app/widgets/sensorsInfo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class WorkingOut extends StatefulWidget {
  final String workoutType;

  const WorkingOut({
    Key key,
    @required this.workoutType,
  }) : super(key: key);

  @override
  _WorkingOutState createState() => _WorkingOutState();
}

class _WorkingOutState extends State<WorkingOut> {
  final geo = GeoService();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,       //disable the system back button
      child: FutureProvider(
        create: (content) => geo.getCurrentLocation(),  //current location of the user
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Column(
            children: <Widget>[
              SafeArea(
                top: true,
                left: true,
                right: true,
                child: Container(
                  width: double.infinity,
                  height: 400.0,
                  child: Consumer<Position>(builder: (context, position, widget){
                    return (position == null) ?
                      Center(child: CircularProgressIndicator()) : ShowMap(position);   //TODO: comment
                  }),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                child: SensorsInfo(workoutType: widget.workoutType),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Buttons(
                  name: "End",
                  press: (() => Navigator.of(context).pushReplacementNamed('/home')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}