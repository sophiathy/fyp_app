import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class SectionCard extends StatelessWidget {
  final double height;
  final String title;
  final Widget topRightButton;
  final Widget content;

  const SectionCard({
    this.height,
    this.title,
    this.topRightButton,
    this.content,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getProportionWidth(22.0)),
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).indicatorColor,
        borderRadius: BorderRadius.circular(getProportionWidth(36.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.headline6,
              ),
              Spacer(),
              //used in startExSection
              topRightButton,
            ],
          ),

          //Widget
          content,
        ],
      ),
    );
  }
}
