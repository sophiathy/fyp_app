import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/authAccount.dart';
import 'package:fyp_app/theme/adaptiveSize.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/widgets/settingsOptions.dart';
import 'package:provider/provider.dart';

class SettingsDrawer extends StatefulWidget {
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
    DarkProvider modeSwitch = Provider.of<DarkProvider>(context);
    final AuthAccount _authenticate = AuthAccount();
    User user = FirebaseAuth.instance.currentUser;

    // String _profileImage = "url";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(getProportionWidth(28.0)),
        children: <Widget>[
          Container(
            height: getProportionHeight(230.0),
            child: DrawerHeader(
              child: Column(
                children: <Widget>[
                  //profile picture
                  // Container(
                  //   height: 100.0,
                  //   width: 100.0,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     image: DecorationImage(
                  //       image: NetworkImage(_profileImage),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  Icon(
                    Icons.account_circle_rounded,
                    color: Theme.of(context).primaryColor,
                    size: getProportionWidth(90.0),
                  ),
                  SizedBox(height: getProportionHeight(18.0)),
                  //user email account
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: getProportionWidth(14.0),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // SettingsOptions(
          //   icon: Icons.account_circle_rounded,
          //   title: "My Profile",
          //   tap: () {
          //     Navigator.of(context).pushNamed('/profile');
          //   },
          // ),
          SettingsOptions(
            icon: Icons.import_contacts_rounded,
            title: "User Manual",
            tap: (() =>
                Navigator.of(context).pushReplacementNamed('/userManual')),
          ),
          SettingsOptions(
            icon: Icons.info_rounded,
            title: "About",
            tap: (() => Navigator.of(context).pushReplacementNamed('/about')),
          ),
          SettingsOptions(
            icon: Icons.logout,
            title: "Logout",
            tap: () async {
              setState(() {
                modeSwitch.themeData = false; //reset to light mode
                print("Logout Successfully.");
              });

              //update the stream to null
              await _authenticate.logout().then((_) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              });
            },
          ),
        ],
      ),
    );
  }
}
