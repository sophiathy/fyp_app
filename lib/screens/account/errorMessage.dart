import 'package:flutter/material.dart';

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
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      children: <Widget>[
        Icon(
          Icons.error_outline_rounded,
          color: Colors.red,
        ),
        SizedBox(width: 5.0),
        Text(
          warning,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
  }
}

