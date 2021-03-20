import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class RecordOptions extends StatefulWidget {
  final int index;
  final String timestamp;
  final String type;
  final Function tap;

  const RecordOptions({
    Key key,
    this.index,
    this.timestamp,
    this.type,
    this.tap,
  }) : super(key: key);

  @override
  _RecordOptionsState createState() => _RecordOptionsState();
}

class _RecordOptionsState extends State<RecordOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: (widget.index % 2 == 0) ? Colors.indigo[100].withOpacity(0.2) : Colors.white.withOpacity(0.1),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: getProportionWidth(12.0)),
            Container(
              width: getProportionWidth(100.0),
              child: Text(
                widget.timestamp,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      fontSize: getProportionWidth(11.0),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            SizedBox(width: getProportionWidth(12.0)),
            Text(
              widget.type,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontSize: getProportionWidth(11.0),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        onTap: widget.tap,
      ),
    );
  }
}
