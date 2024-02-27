import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/HomePage.dart';
import 'package:project_manager/Screens/RegisterScreen.dart';
import 'package:project_manager/Screens/ForgotPassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  InputField(
                    label: 'Password',
                    password: true,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()),
                          );
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: kBottomAppColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
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
                    label: 'Login',
                  ),
                  CustomButton(
                    txtColor: kLightColor,
                    bgColor: kBottomAppColor,
                    callBackFunction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    label: 'Register',
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
