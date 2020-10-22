import 'package:flutter/material.dart';
import 'package:fyp_app/constants.dart';

class Buttons extends StatelessWidget {
  final String name;
  final Function press;
  
  const Buttons({
    Key key,
    this.name,
    this.press,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60.0,
      child: FlatButton(
        color: kIndigoColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: press,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 28.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}