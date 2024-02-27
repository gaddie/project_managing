import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';

import 'package:project_manager/Screens/OtpScreen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Image(
                      image: AssetImage('images/logo.png'),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  InputField(label: 'Email'),
                  CustomButton(
                    txtColor: kLightColor,
                    bgColor: kBottomAppColor,
                    callBackFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtpScreen()),
                      );
                    },
                    label: 'Send OTP',
                  ),
                  CustomButton(
                    txtColor: kLightColor,
                    bgColor: kBottomAppColor,
                    callBackFunction: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    label: 'Back',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
