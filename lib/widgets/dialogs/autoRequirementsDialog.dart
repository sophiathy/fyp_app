import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:hive/hive.dart';

autoRequirementsDialog(BuildContext context) {
  Box<int> settingsBox =
      Hive.box('settings'); //unlock "Auto" requirements(key 20-23)
  int walkingRequiredKey = 20;
  int walkingUpstairsRequiredKey = 21;
  int walkingDownstairsRequiredKey = 22;
  int runningRequiredKey = 23;

  return AwesomeDialog(
    context: context,
    animType: AnimType.SCALE,
    dialogType: DialogType.INFO,
    headerAnimationLoop: false,
    buttonsBorderRadius: BorderRadius.all(Radius.circular(10.0)),
    body: Column(
      children: <Widget>[
        SizedBox(height: getProportionWidth(13.0)),
        Text(
          '~ Mission ~\nUnlock Auto Tracking Mode',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6.copyWith(
            fontSize: getProportionWidth(18.0),
          ),
        ),
        SizedBox(height: getProportionWidth(18.0)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionWidth(25.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              settingsBox.get(walkingRequiredKey, defaultValue: 2) == 0
              ? SizedBox(width: 0.0)
              : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: getProportionWidth(150.0),
                    child: Text(
                      "Walking: ",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: getProportionWidth(14.0),
                            fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${settingsBox.get(walkingRequiredKey, defaultValue: 2)} time(s)",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: getProportionWidth(14.0),
                          fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              settingsBox.get(walkingUpstairsRequiredKey, defaultValue: 2) == 0
              ? SizedBox(width: 0.0)
              : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: getProportionWidth(150.0),
                    child: Text(
                      "Walking Upstairs: ",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: getProportionWidth(14.0),
                            fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${settingsBox.get(walkingUpstairsRequiredKey, defaultValue: 2)} time(s)",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: getProportionWidth(14.0),
                          fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              settingsBox.get(walkingDownstairsRequiredKey, defaultValue: 2) == 0
              ? SizedBox(width: 0.0)
              : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: getProportionWidth(150.0),
                    child: Text(
                      "Walking Downstairs: ",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: getProportionWidth(14.0),
                            fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${settingsBox.get(walkingDownstairsRequiredKey, defaultValue: 2)} time(s)",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: getProportionWidth(14.0),
                          fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              settingsBox.get(runningRequiredKey, defaultValue: 2) == 0
              ? SizedBox(width: 0.0)
              : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: getProportionWidth(150.0),
                    child: Text(
                      "Running: ",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontSize: getProportionWidth(14.0),
                            fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${settingsBox.get(runningRequiredKey, defaultValue: 2)} time(s)",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: getProportionWidth(14.0),
                          fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionWidth(8.0)),
      ],
    ),
    btnOkOnPress: () {
      debugPrint('User pressed GOT IT!');
    },
    btnOkIcon: Icons.check_circle,
    btnOkText: 'Ok. Got it.',
    onDissmissCallback: () {
      debugPrint('Dialog Dismiss...');
    },
  )..show();
}
