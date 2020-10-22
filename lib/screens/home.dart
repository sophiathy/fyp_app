import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/sections/StartExSection.dart';
import 'package:fyp_app/sections/SummarySection.dart';
import 'package:fyp_app/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _profileImage = "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260";
  
  //default: light mode
  bool modeSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: modeSwitch? kColorBehind_dark : kColorBehind_light,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            //app bar
            SafeArea(
              top: true,
              left: true,
              right: true,
              child: Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: (){
                        setState((){
                          modeSwitch = !modeSwitch;
                        });
                      },
                      icon: modeSwitch
                        ? Icon(
                            Icons.wb_sunny,
                            size: 20.0,
                            color: modeSwitch? kSectionBackground_light : kSectionBackground_dark,
                        )
                        : Icon(
                            Icons.brightness_2,
                            size: 20.0,
                            color: modeSwitch? kSectionBackground_light : kSectionBackground_dark,
                        ),
                    ),

                    Spacer(),

                    //profile settings
                    Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(_profileImage),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Today's Summary
            SummarySection(modeSwitch: modeSwitch),

            //Start an Exercise
            StartExSection(modeSwitch: modeSwitch),



          ],
        ),
      ),
    );
  }
}


