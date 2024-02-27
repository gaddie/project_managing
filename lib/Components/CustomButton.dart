import 'package:project_manager/Constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {required this.callBackFunction,
      required this.label,
      required this.bgColor,
      required this.txtColor});

  final VoidCallback callBackFunction;
  final String label;
  final bgColor;
  final txtColor;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          widget.callBackFunction();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 17),
          child: Text(
            widget.label,
            style: TextStyle(color: widget.txtColor, fontSize: kNormalFontSize),
          ),
        ),
      ),
    );
  }
}
