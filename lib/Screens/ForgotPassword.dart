import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
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
                    InputField(
                      label: 'Email',
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    CustomButton(
                      txtColor: kLightColor,
                      bgColor: kBottomAppColor,
                      callBackFunction: () async {
                        try {
                          setState(() {
                            showSpinner = true;
                          });
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email);
                          // Password reset email sent successfully
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Success'),
                                content: Text(
                                    'A reset link has been sent to ${email}'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          // Handle errors
                          print(e);
                        }
                      },
                      label: 'Reset Email',
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
      ),
    );
  }
}
