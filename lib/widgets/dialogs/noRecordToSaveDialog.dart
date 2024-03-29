import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

//No record will be saved if user pressed on the "leave" button
noRecordToSaveDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(10.0)),
        dialogType: DialogType.NO_HEADER,
        body: Column(
          children: <Widget>[
            SizedBox(height: getProportionWidth(32.0)),
            Text(
              'No workout record has been saved.',
              style: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(
                  fontStyle: FontStyle.normal,
                  fontSize: getProportionWidth(14.0),
                ),
            ),
            SizedBox(height: getProportionWidth(22.0)),
          ],
        ),
        btnOkOnPress: () {
          debugPrint('User pressed OK');
          Navigator.of(context).pushReplacementNamed('/home'); //stopwatch had not started = no record of workout
        },
        btnOkIcon: Icons.check_circle,
        btnOkText: 'Ok. Return to Home.',
        onDissmissCallback: () {
          debugPrint('Dialog Dismiss...');
        },
      )..show();
  }