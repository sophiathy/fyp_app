import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';
import 'package:hive/hive.dart';

class ToggleTrackingModeBtn extends StatefulWidget {
  final int trackingModeKey;

  const ToggleTrackingModeBtn({Key key, this.trackingModeKey}) : super(key: key);

  @override
  _ToggleTrackingModeBtnState createState() => _ToggleTrackingModeBtnState();
}

class _ToggleTrackingModeBtnState extends State<ToggleTrackingModeBtn> {
  Box<int> settingsBox = Hive.box('settings'); //key 0: store the tracking mode (manual = 0 / auto = 1), unlock "Auto" requirements(key 20-24)
  int isAuto = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      isAuto = settingsBox.get(widget.trackingModeKey, defaultValue: 0); //key 0: manual = 0, auto = 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            setState(() {
              isAuto = 0;
              settingsBox.put(widget.trackingModeKey, isAuto);
            });
          },
          style: ElevatedButton.styleFrom(
            primary: isAuto == 0 ? kPrimaryColor_light : kDisabled,
            padding: EdgeInsets.all(getProportionWidth(2.0)),
            minimumSize:
                Size(getProportionWidth(55.0), getProportionHeight(18.0)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(getProportionWidth(8.0)),
                    bottomLeft: Radius.circular(getProportionWidth(8.0)))),
          ),
          child: Text(
            "Manual".toUpperCase(),
            style: TextStyle(
              fontSize: getProportionWidth(10.0),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isAuto = 1;
              settingsBox.put(widget.trackingModeKey, isAuto);
            });
          },
          style: ElevatedButton.styleFrom(
              primary: isAuto == 0 ? kDisabled : kStopOrAutoBtn,
              padding: EdgeInsets.all(getProportionWidth(2.0)),
              minimumSize:
                  Size(getProportionWidth(42.0), getProportionHeight(18.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(getProportionWidth(8.0)),
                      bottomRight: Radius.circular(getProportionWidth(8.0))))),
          child: Text(
            "Auto".toUpperCase(),
            style: TextStyle(
              fontSize: getProportionWidth(10.0),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
