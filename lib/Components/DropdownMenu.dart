import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String dropdownValue = '';
  List<String> list = ['Project Name']; // Updated to be non-constant

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget is initialized
  }

  Future<void> fetchData() async {
    // Simulating fetching data from a database
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Update the list with fetched data
      list = ['Project 1', 'Project 2', 'Project 3', 'Project 4'];
      dropdownValue = list.isNotEmpty ? list.first : ''; // Set initial value
    });
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
              if (list.contains(value)) {
                setState(() {
                  dropdownValue = value ?? '';
                });
              }
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
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
