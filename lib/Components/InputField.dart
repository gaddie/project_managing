import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  InputField(
      {required this.label,
      this.password = false,
      this.onChanged,
      this.integerOnly = false});

  String label;
  bool password;
  final ValueChanged<String>? onChanged;
  final bool integerOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: kBottomAppColor,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            obscureText: password,
            onChanged: onChanged,
            inputFormatters:
                integerOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              filled: true, // Set to true for a filled input field
              fillColor: kLightColor, // Specify the background color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: kLightColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: kDarkColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
