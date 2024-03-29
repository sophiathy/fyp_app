import 'package:flutter/material.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/constants.dart';

class PageIndicator extends StatelessWidget {
  final int current;
  final int pageNo;

  const PageIndicator({
    Key key,
    this.current,
    this.pageNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
      margin: EdgeInsets.only(right: getProportionWidth(5.0)),
      height: getProportionHeight(8.0),
      width: current == pageNo ? getProportionWidth(22.0) : getProportionWidth(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getProportionWidth(5.0)),
        color: current == pageNo ? Theme.of(context).primaryColor : kDisabled,
      ),
    );
  }
}