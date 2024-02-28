import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';

class DateField extends StatefulWidget {
  DateField({
    required this.label,
    required this.onChanged,
  });

  final String label;
  final ValueChanged<DateTime> onChanged;

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: kBottomAppColor,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: AbsorbPointer(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0,
                  ),
                  filled: true,
                  fillColor: kLightColor,
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
                  // Update the text field with the selected date
                  // Use a formatted string to display the date
                  hintText:
                      "${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Set initial date to _selectedDate
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      // Pass the selected date back to the parent widget
      widget.onChanged(picked);
    }
  }
}
