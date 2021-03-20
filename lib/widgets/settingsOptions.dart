import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class SettingsOptions extends StatefulWidget {
  final IconData icon;
  final String title;
  final Function tap;

  const SettingsOptions({
    Key key,
    this.icon,
    this.title,
    this.tap,
  }) : super(key: key);

  @override
  _SettingsOptionsState createState() => _SettingsOptionsState();
}

class _SettingsOptionsState extends State<SettingsOptions> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            widget.icon,
            color: Theme.of(context).primaryColor,
            size: getProportionWidth(33.0),
          ),
          SizedBox(width: getProportionWidth(20.0)),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: getProportionWidth(18.0),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
      onTap: widget.tap,
    );
  }
}
