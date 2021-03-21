import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class ManualContent extends StatelessWidget {
  final String image, title, desc;

  const ManualContent({
    Key key,
    this.image,
    this.title,
    this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: getProportionWidth(30.0)),
        SvgPicture.asset(
          image,
          height: getProportionWidth(180.0),
          width: getProportionWidth(200.0),
        ),
        SizedBox(height: getProportionWidth(30.0)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionWidth(12.0)),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        SizedBox(height: getProportionWidth(25.0)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionWidth(30.0)),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontSize: getProportionWidth(16.0),
            ),
          ),
        ),
        SizedBox(height: getProportionWidth(20.0)),
      ],
    );
  }
}