import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDropdownMenu extends StatefulWidget {
  final Function(String) onValueChanged;

  MyDropdownMenu({required this.onValueChanged});

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  late String dropdownValue; // Changed to late initialization

  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
  late List<String> projects = [];

  @override
  void initState() {
    super.initState();
    dropdownValue = ''; // Initialize with empty string
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        getProjects();
      }
    } catch (e) {
      print(e);
    }
  }

  void getProjects() async {
    try {
      final snapshot = await _firestore
          .collection('projects')
          .where('user', isEqualTo: loggedInUser.email)
          .get();
      List<String> projectNames = [];
      for (var doc in snapshot.docs) {
        projectNames.add(doc['projectName']);
      }
      setState(() {
        projects = projectNames;
        dropdownValue =
            projects.isNotEmpty ? projects.first : ''; // Set dropdownValue
        widget.onValueChanged(dropdownValue); // Notify parent widget
      });
    } catch (e) {
      print('Error fetching projects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            elevation: 8,
            isExpanded: true,
            value: dropdownValue.isNotEmpty ? dropdownValue : null,
            onChanged: (String? value) {
              // Check if the selected value is present in the list
              if (projects.contains(value)) {
                setState(() {
                  dropdownValue = value ?? '';
                  widget.onValueChanged(dropdownValue);
                });
              }
            },
            items: projects.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
