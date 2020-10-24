import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/darkProvider.dart';
import 'package:fyp_app/sections/startExSection.dart';
import 'package:fyp_app/sections/summarySection.dart';
import 'package:fyp_app/constants.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _profileImage = "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260";

  @override
  Widget build(BuildContext context) {
    DarkProvider modeSwitch = Provider.of<DarkProvider>(context);

    final AuthService _authenticate = AuthService();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                    //mode switcher
                    IconButton(
                      //TODO:Explain in report
                      onPressed: (){
                        setState((){
                          modeSwitch.themeData = !modeSwitch.themeData;
                        });
                      },
                      icon: modeSwitch.themeData
                        ? Icon(
                            //sunny icon in dark mode
                            Icons.wb_sunny,
                            size: 20.0,
                            color: kSectionBackground_light,
                        )
                        : Icon(
                            //moon icon in light mode
                            Icons.brightness_2,
                            size: 20.0,
                            color: kSectionBackground_dark,
                        ),
                    ),

                    Spacer(),

                    //TODO:Profile Settings
                    //profile settings
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () async{
                          await _authenticate.logout();   //update the stream to null
                        },
                        child: Container(
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
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Today's Summary
            SummarySection(modeSwitch: modeSwitch.themeData),

            //Start an Exercise
            StartExSection(modeSwitch: modeSwitch.themeData),



          ],
        ),
      ),
    );
  }
}


