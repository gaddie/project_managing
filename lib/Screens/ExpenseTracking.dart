import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:project_manager/Components/DropdownMenu.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/TextField.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/Components/MessageHandler.dart';
import '../Components/DateField.dart';

class ExpenseTracking extends StatefulWidget {
  @override
  State<ExpenseTracking> createState() => _ExpenseTrackingState();
}

class _ExpenseTrackingState extends State<ExpenseTracking> {
  final _firestore = FirebaseFirestore.instance;
  String selectedOption = 'Income';
  late String selectedDropdownValue;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  late List<Map<String, dynamic>> projects = [];
  bool errorMessage = false;
  String amount = '';
  String description = '';
  DateTime? spendDate;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    selectedDropdownValue = 'Project Name';
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      body: SafeArea(
        child: ListView(children: [
          DelayedDisplay(
            delay: Duration(microseconds: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Add Income Or Expense',
                    style: TextStyle(
                        fontSize: kTitleFontSize, color: kBottomAppColor),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: IncomeSlider(
                            label: 'Income',
                            isSelected: selectedOption == 'Income',
                            onTapCallback: () {
                              setState(() {
                                selectedOption = 'Income';
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: IncomeSlider(
                            label: 'Expense',
                            isSelected: selectedOption == 'Expense',
                            onTapCallback: () {
                              setState(() {
                                selectedOption = 'Expense';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Text(
                    'Project Name',
                    style: TextStyle(
                        color: kBottomAppColor, fontSize: kNormalFontSize),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: MyDropdownMenu(
                      onValueChanged: (value) {
                        setState(() {
                          selectedDropdownValue =
                              value; // Update selected value
                        });
                      },
                    )),
                InputField(
                  label: 'Amount',
                  integerOnly: true,
                  errorText: errorMessage ? 'This field is required' : null,
                  onChanged: (value) {
                    amount = value;
                  },
                ),
                DateField(
                  label: 'Date',
                  onChanged: (DateTime selectedDate) {
                    setState(() {
                      spendDate = selectedDate;
                    });
                  },
                ),
                ProjectForm(
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CustomButton(
                    txtColor: kBottomAppColor,
                    bgColor: kLightColor,
                    callBackFunction: () {
                      if (mounted) {
                        if (amount.isEmpty) {
                          setState(() {
                            errorMessage = true;
                          });
                        } else {
                          if (selectedDropdownValue.isNotEmpty) {
                            if (spendDate == null) {
                              spendDate = DateTime.now();
                            }
                            _firestore.collection('costs').add({
                              'user': loggedInUser.email,
                              'amount': amount,
                              'description': description,
                              'expenseType': selectedOption,
                              'projectName': selectedDropdownValue,
                              'date': spendDate,
                            }).then((_) {
                              // Show message after adding data to Firestore
                              MessageHandler.showMessage(
                                  context,
                                  'Your amount has been added',
                                  kBottomAppColor);
                            }).catchError((error) {
                              // Handle error while adding data to Firestore
                              print('Error adding document: $error');
                            });
                          } else {
                            print('you have to create a project');
                          }
                        }
                      }
                    },
                    label: 'Add',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    txtColor: kLightColor,
                    bgColor: kBottomAppColor,
                    callBackFunction: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    label: 'Back',
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// income and expense button animation
class IncomeSlider extends StatelessWidget {
  const IncomeSlider({
    required this.isSelected,
    required this.onTapCallback,
    required this.label,
  });

  final bool isSelected;
  final VoidCallback onTapCallback;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? kBottomAppColor : kLightColor,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? kLightColor : kBottomAppColor,
            ),
          ),
        ),
      ),
    );
  }
}
