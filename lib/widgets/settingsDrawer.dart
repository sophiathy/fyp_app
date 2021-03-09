import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app/services/authAccount.dart';
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

    // String _profileImage =
    //     "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          Container(
            height: 250.0,
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
                    size: 100.0,
                  ),
                  SizedBox(height: 20.0),
                  //user email account
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 16.0,
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
            tap: () {},
          ),
          SettingsOptions(
            icon: Icons.info_rounded,
            title: "About",
            tap: () {},
          ),
          SettingsOptions(
            icon: Icons.logout,
            title: "Logout",
            tap: () async {
              setState(() {
                modeSwitch.themeData = false; //reset to light mode
                print("Logout Successfully.");
              });

              await _authenticate.logout(); //update the stream to null
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
