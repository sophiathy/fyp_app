import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

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
      height: getProportionHeight(58.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          //button background color
          primary: Theme.of(context).buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                      getProportionWidth(20.0))),
          ),
        onPressed: press,
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
            fontSize: getProportionWidth(23.0),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}