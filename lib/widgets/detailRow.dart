import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String title;
  final String content;
  const DetailRow({
    Key key,
    @required this.title, this.content,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(
                fontSize: 20.0,
              ),
        ),
        Text(
          content,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(
                fontSize: 20.0,
              ),
        ),
      ],
    );
  }
}
