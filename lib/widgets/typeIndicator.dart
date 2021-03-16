import 'package:flutter/material.dart';

class TypeIndicator extends StatelessWidget {
  final String type;
  final Color color;
  final Color textColor;

  const TypeIndicator({Key key, this.type, this.color, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.0),
          Text(
            type,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
