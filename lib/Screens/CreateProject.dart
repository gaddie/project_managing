import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:project_manager/Components/InputField.dart';
import 'package:project_manager/Components/TextField.dart';
import 'package:project_manager/Components/CustomButton.dart';
import 'package:delayed_display/delayed_display.dart';

class CreateProject extends StatefulWidget {
  const CreateProject({Key? key}) : super(key: key);

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLightColor,
      appBar: AppBar(
        backgroundColor: kBgLightColor,
        title: Text(
          'Create Project',
          style: TextStyle(color: kBottomAppColor),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kDarkColor,
          ),
          onPressed: () {
            Navigator.pop(
                context); // This will pop the current page off the stack
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: DelayedDisplay(
                delay: Duration(microseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputField(label: 'Project Name'),
                    InputField(label: 'Start Up cost'),
                    InputField(label: 'Start Date'),
                    InputField(label: 'End Date'),
                    ProjectForm(),
                    CustomButton(
                      txtColor: kLightColor,
                      bgColor: kBottomAppColor,
                      callBackFunction: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      label: 'Create Project',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
