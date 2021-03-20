import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(getProportionWidth(25.0)),
          height: getProportionWidth(180.0),
          width: getProportionWidth(180.0),
          decoration: BoxDecoration(
            color: Theme.of(context).indicatorColor,
            borderRadius: BorderRadius.circular(getProportionWidth(18.0)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: getProportionWidth(3.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SpinKitCircle(
                  size: getProportionWidth(75.0),
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: getProportionHeight(10.0)),
                Text(
                  "Loading".toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: getProportionWidth(16.0),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
