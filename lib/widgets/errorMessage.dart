import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class ErrorMessage extends StatelessWidget {
  final List<String> errors;

  const ErrorMessage({
    Key key,
    @required this.errors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length, (index) => warningText(errors[index])),
    );
  }

  Padding warningText(String warning) {
    return Padding(
    padding: EdgeInsets.symmetric(vertical: getProportionWidth(5.0)),
    child: Row(
      children: <Widget>[
        Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
        ),
        SizedBox(width: getProportionWidth(5.0)),
        Text(
          warning,
          style: TextStyle(
            fontSize: getProportionWidth(14.0),
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
  }
}

