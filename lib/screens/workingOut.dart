import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:fyp_app/widgets/buttons.dart';
import 'package:fyp_app/widgets/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class WorkingOut extends StatefulWidget {
  @override
  _WorkingOutState createState() => _WorkingOutState();
}

class _WorkingOutState extends State<WorkingOut> {
  final geo = GeoService();

  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (content) => geo.getCurrentLocation(),  //current location of the user
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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

              SizedBox(height: 100.0),

              Buttons(
                name: "End",
                press: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}