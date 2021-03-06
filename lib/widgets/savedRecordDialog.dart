import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

//Workout record will be saved if user stopped the stopwatch
savedRecordDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        headerAnimationLoop: false,
        body: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            Text(
              'Well Done!',
              style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(
                  fontSize: 20.0,
                ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Your workout record has been saved.',
              style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(
                  fontSize: 16.0,
                ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
        btnOkOnPress: () {
          debugPrint('User pressed OK');
        },
        btnOkIcon: Icons.check_circle,
        btnOkText: 'Nice',
        onDissmissCallback: () {
          debugPrint('Dialog Dismiss...');
        },
      )..show();
  }