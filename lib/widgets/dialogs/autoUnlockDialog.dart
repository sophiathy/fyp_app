import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

autoUnlockDialog(BuildContext context) {
    return AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.SUCCES,
        headerAnimationLoop: false,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(10.0)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionWidth(22.0)),
          child: Column(
            children: <Widget>[
              SizedBox(height: getProportionWidth(12.0)),
              Text(
                'Auto Tracking Mode Unlocked!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(
                    fontSize: getProportionWidth(18.0),
                  ),
              ),
              SizedBox(height: getProportionWidth(18.0)),
              Text(
                'Congratulations! Auto tracking mode has been unlocked for you.',
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(
                    fontSize: getProportionWidth(14.0),
                  ),
              ),
              SizedBox(height: getProportionWidth(8.0)),
              Text(
                'Auto tracking mode will help you\nto identify the workout types automatically while tracking.',
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(
                    fontSize: getProportionWidth(14.0),
                  ),
              ),
              SizedBox(height: getProportionWidth(14.0)),
              Text(
                'Try it out now!',
                textAlign: TextAlign.center,
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
        ),
        btnOkOnPress: () {
          debugPrint('User pressed GREAT!');
        },
        btnOkIcon: Icons.check_circle,
        btnOkText: 'Great',
        onDissmissCallback: () {
          debugPrint('Dialog Dismiss...');
        },
      )..show();
  }