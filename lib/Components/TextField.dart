import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';

class ProjectForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              color: kBottomAppColor,
              fontSize: kNormalFontSize,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            maxLines: 5, // Set the number of lines you want for the description
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
              filled: true,
              fillColor: kLightColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: kLightColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: kDarkColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
