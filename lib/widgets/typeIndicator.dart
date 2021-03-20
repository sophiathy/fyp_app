import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class TypeIndicator extends StatelessWidget {
  final String type;
  final Color color;
  final Color textColor;

  const TypeIndicator({Key key, this.type, this.color, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionWidth(2.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: getProportionWidth(13.0),
            height: getProportionWidth(13.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: getProportionWidth(8.0)),
          Text(
            type,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: getProportionWidth(12.0),
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
