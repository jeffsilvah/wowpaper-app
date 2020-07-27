import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign align;
  final Color color;
  final double size;
  final FontWeight weight;
  final double spacing;

  CustomText({this.weight, this.text, this.align, this.color, this.size, this.spacing});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontFamily: 'Saira',
        fontSize: size,
        fontWeight: weight,
        letterSpacing: spacing,
      ),
    );
  }
}