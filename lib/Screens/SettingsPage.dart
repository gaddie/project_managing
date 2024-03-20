import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Constants.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {
  bool Dark = false;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.brightness_2,
          color: Colors.white,
        );
      }
      return const Icon(Icons.sunny);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: ListView(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: kBottomAppColor,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: kTitleFontSize,
                          color: kBottomAppColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Account Management',
                  style: TextStyle(color: kDarkGrey),
                ),
              ),
              // Account management tab
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kGreyColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Username',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkGrey,
                              ),
                              onPressed: () {
                                print('pressed');
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.security,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkGrey,
                              ),
                              onPressed: () {
                                print('pressed');
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // dark mode tab
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kGreyColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.mode,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Dark Mode',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            Switch(
                              activeColor: Colors.grey,
                              activeTrackColor: kGreyColor,
                              thumbIcon: thumbIcon,
                              value: Dark,
                              onChanged: (bool value) {
                                setState(() {
                                  Dark = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Help tab
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kGreyColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.question_mark,
                                  color: kDarkGrey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Help',
                                  style: TextStyle(
                                      fontSize: kNormalFontSize,
                                      color: kDarkGrey),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: kDarkGrey,
                              ),
                              onPressed: () {
                                print('pressed');
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
