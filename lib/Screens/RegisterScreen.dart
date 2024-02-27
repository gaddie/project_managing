import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/HomePage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  InputField(label: 'Username'),
                  InputField(label: 'Email'),
                  InputField(
                    label: 'Password',
                    password: true,
                  ),
                  InputField(
                    label: 'Confirm Password',
                    password: true,
                  ),
                  CustomButton(
                    txtColor: kLightColor,
                    bgColor: kBottomAppColor,
                    callBackFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    label: 'Register',
                  ),
                  CustomButton(
                    txtColor: kLightColor,
                    bgColor: kBottomAppColor,
                    callBackFunction: () {
                      Navigator.pop(context);
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
