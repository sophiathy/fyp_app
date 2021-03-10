import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        Spacer(),
        SvgPicture.asset(
          image,
          height: 200.0,
          width: 220.0,
        ),
        SizedBox(height: 80.0),
        Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(height: 40.0),
        Text(
          desc,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 80.0),
      ],
    );
  }
}