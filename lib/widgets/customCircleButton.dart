import 'package:flutter/material.dart';

class CustomCircleButton extends StatelessWidget {
  final Color blurColor;
  final Function onTap;
  final double circleRadius;
  final Color circleColor;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  CustomCircleButton({this.blurColor, this.onTap, this.circleRadius, this.circleColor, this.icon, this.iconSize, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: blurColor,
              blurRadius: 5,
              offset: Offset(0, 3)
            )
          ],
          borderRadius: BorderRadius.circular(50)
      ),
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: circleRadius,
          backgroundColor: circleColor,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}