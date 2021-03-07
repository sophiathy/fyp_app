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
          name.toUpperCase(),
          style: TextStyle(
            fontSize: 26.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}