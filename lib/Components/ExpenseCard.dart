import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';

class ExpenseCard extends StatefulWidget {
  ExpenseCard(
      {required this.color,
      required this.date,
      required this.label,
      required this.iconColor,
      required this.icon});

  final Color? color;
  final String date;
  final String label;
  final Color? iconColor;
  final IconData icon;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
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
                          onPressed: () {
                            print('deleted');
                          },
                          icon: Icon(
                            Icons.delete,
                            color: kRedColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            print('edit');
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
