import 'package:flutter/material.dart';
import 'package:project_manager/Constants.dart';
import 'package:animations/animations.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({
    required this.label,
    required this.icon,
    required this.onButtonPressed,
  });

  final IconData icon;
  final String label;
  final Widget Function() onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
      child: OpenContainer(
        closedColor: kBottomAppColor,
        transitionType: ContainerTransitionType.fade,
        openBuilder: (BuildContext context, VoidCallback _) {
          return onButtonPressed() ??
              Container(); // Return the result of onButtonPressed, or an empty container if null
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ), // Adjust the radius as needed
        ),
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return InkWell(
            onTap: openContainer,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: kGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: kDarkColor,
                          blurRadius: 10.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            icon,
                            color: kLightColor,
                            size: 40.0,
                          ),
                          Text(
                            label,
                            style: TextStyle(
                              color: kLightColor,
                              fontSize: kNormalFontSize,
                            ),
                          ),
                          Icon(
                            Icons.more_vert,
                            color: kLightColor,
                            size: 25.0,
                          ),
                        ],
                      ),
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
