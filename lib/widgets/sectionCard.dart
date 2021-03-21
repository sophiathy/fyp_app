import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget topRightButton;
  final Widget content;

  const SectionCard({
    this.title,
    this.topRightButton,
    this.content,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getProportionWidth(22.0)),
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
          Padding(
            padding: EdgeInsets.only(top: getProportionWidth(10.0)),
            child: content,
          ),
        ],
      ),
    );
  }
}
