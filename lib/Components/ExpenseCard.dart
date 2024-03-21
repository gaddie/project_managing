import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_manager/Components/MessageHandler.dart';

class ExpenseCard extends StatefulWidget {
  ExpenseCard({
    required this.color,
    required this.cost,
    required this.date,
    required this.label,
    required this.iconColor,
    required this.icon,
    required this.amount,
    required this.costId,
    required this.onDelete,
  });

  final Color? color;
  final List cost;
  final String date;
  final String label;
  final Color? iconColor;
  final IconData icon;
  final String amount;
  final VoidCallback onDelete;
  final String costId;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  bool errorMessage = false;
  String newCost = '';

  void editCost(String costId, String newData) async {
    try {
      if (newData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('costs')
            .doc(costId)
            .update({'amount': newData});
        MessageHandler.showMessage(
            context, 'You have edited successfully', kBottomAppColor);
      } else {
        MessageHandler.showMessage(
            context, 'Please enter an amount', kBottomAppColor);
      }
    } catch (e) {
      print('Error editing expense type: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kLightColor,
              boxShadow: [
                BoxShadow(
                  color: kGreyColor,
                  blurRadius: 10.0,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.icon,
                          size: 40,
                          color: widget.iconColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 45,
                          width: 3,
                          color: kBgLightColor,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.label,
                                style: TextStyle(
                                    fontSize: kNormalFontSize,
                                    color: kBottomAppColor),
                              ),
                              Text(
                                '${widget.amount}',
                                style: TextStyle(color: kBottomAppColor),
                              ),
                              Text(
                                widget.date,
                                style: TextStyle(color: kBottomAppColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: widget.onDelete,
                          icon: Icon(
                            Icons.delete,
                            color: kRedColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Enter New Amount'),
                                  content: Container(
                                    width: 300,
                                    height: 100,
                                    child: InputField(
                                      label: 'New amount',
                                      errorText: errorMessage
                                          ? 'This field is required'
                                          : null,
                                      integerOnly: true,
                                      onChanged: (value) {
                                        newCost = value;
                                      },
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        editCost(widget.costId, newCost);
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('Edit'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('Back'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.edit,
                            color: kGreenColor,
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
