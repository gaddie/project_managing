import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

  //Function to validate email format
  bool isValidEmail(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
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
                    InputField(
                      label: 'Password',
                      password: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    CustomButton(
                      txtColor: kLightColor,
                      bgColor: kBottomAppColor,
                      callBackFunction: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        if (isValidEmail(email)) {
                          if (password.length >= 8) {
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              if (newUser != null) {
                                Navigator.pushNamed(context, '/homePage');
                              }
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              setState(() {
                                showSpinner = false;
                              });
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'The email address is already in use by another account'),
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
                            }
                          } else {
                            // Show a dialog if the password is less than 8 characters
                            setState(() {
                              showSpinner = false;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Password must be at least 8 characters long'),
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
                          }
                        } else {
                          // Show a dialog if the email is invalid
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text('Invalid Email'),
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
                        }
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
      ),
    );
  }
}
