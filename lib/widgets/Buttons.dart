import 'package:flutter/material.dart';

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
        color: Theme.of(context).buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: press,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 28.0,
            //TODO: think of the text color for button
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}