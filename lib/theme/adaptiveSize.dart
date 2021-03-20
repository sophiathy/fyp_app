import 'package:flutter/material.dart';

class AdaptiveSize{
  static MediaQueryData _mediaQ;
  static double defaultSize;
  static Orientation orientation;
  static double sWidth;
  static double sHeight;

  //initialize data based of media query
  void init(BuildContext context){
    _mediaQ = MediaQuery.of(context);
    orientation = _mediaQ.orientation;
    sWidth = _mediaQ.size.width;        //screen width
    sHeight = _mediaQ.size.height;      //screen height
  }
}

//ui designer used 360 * 640 as standard for android
double getProportionWidth(double w){
  return AdaptiveSize.sWidth * (w / 360.0);
}

double getProportionHeight(double h){
  return AdaptiveSize.sHeight * (h / 640.0);
}