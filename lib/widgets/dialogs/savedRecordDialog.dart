import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

//Workout record will be saved if user stopped the stopwatch
savedRecordDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        headerAnimationLoop: false,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(10.0)),
        body: Column(
          children: <Widget>[
            SizedBox(height: getProportionWidth(12.0)),
            Text(
              'Well Done!',
              style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(
                  fontSize: getProportionWidth(18.0),
                ),
            ),
            SizedBox(height: getProportionWidth(18.0)),
            Text(
              'Your workout record has been saved.',
              style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(
                  fontSize: getProportionWidth(14.0),
                ),
            ),
            SizedBox(height: getProportionWidth(8.0)),
          ],
        ),
        btnOkOnPress: () {
          debugPrint('User pressed NICE');
        },
        btnOkIcon: Icons.check_circle,
        btnOkText: 'Nice',
        onDissmissCallback: () {
          debugPrint('Dialog Dismiss...');
        },
      )..show();
  }