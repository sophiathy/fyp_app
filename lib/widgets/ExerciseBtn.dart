import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';

class ExerciseBtn extends StatelessWidget {
  final String type;
  final Function press;
  
  const ExerciseBtn({
    Key key,
    @required this.modeSwitch,
    this.type,
    this.press,
  }) : super(key: key);

  final bool modeSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: modeSwitch ? kIconBg_dark : kSectionBackground_light,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.lightBlueAccent,
        ),
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),  //shape of tapping
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Column(
              children: <Widget>[
                _typeIcon(type),

                SizedBox(height: 5.0),
                
                Text(
                  type.toUpperCase(),
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _typeIcon(String type) {
  if(type == "Walking"){
    return Icon(
      Icons.directions_walk_outlined,
      color: Colors.lightBlueAccent,
      size: 30.0,
    );
  }else if (type == "Running"){
    return Icon(
      Icons.directions_run_outlined,
      color: Colors.lightBlueAccent,
      size: 30.0,
    );
  }else if(type == "Biking"){
    return Icon(
      Icons.directions_bike_outlined,
      color: Colors.lightBlueAccent,
      size: 30.0,
    );
  }else{
    return Icon(
      Icons.more_horiz_outlined,
      color: Colors.lightBlueAccent,
      size: 30.0,
    );
  }
}