import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:animations/animations.dart';

class ReusableContainer extends StatelessWidget {
  ReusableContainer({
    required this.label,
    required this.onButtonPressed,
    required this.condition,
    this.color,
  });

  final String label;
  final String condition;
  final Color? color;
  final Widget Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: OpenContainer(
        closedColor: kLightColor,
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return onButtonPressed() ??
              Container(); // Return the result of onButtonPressed, or an empty container if null
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return InkWell(
            onTap: openContainer,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kLightColor,
                        blurRadius: 10.0,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 40,
                          color: color ?? kBgLightColor,
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
                                label,
                                style: TextStyle(
                                    fontSize: kNormalFontSize,
                                    color: kBottomAppColor),
                              ),
                              Text(
                                condition,
                                style: TextStyle(color: kBottomAppColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
