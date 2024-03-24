import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  RoundButton({required this.icon, required this.callBackFunction});

  final IconData icon;
  final VoidCallback callBackFunction;

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        widget.callBackFunction();
      },
      child: Icon(widget.icon),
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(4),
      ),
    );
  }
}
