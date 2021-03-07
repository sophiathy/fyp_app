import 'package:flutter/material.dart';

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
            size: 35.0,
          ),
          SizedBox(width: 20.0),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
      onTap: widget.tap,
    );
  }
}
