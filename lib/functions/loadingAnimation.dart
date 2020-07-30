import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wowpaper/constants/colors.dart';

Center loadingAnimation({double size, double radius}) {
  return Center(
    child: SpinKitDoubleBounce(
      size: size,
      itemBuilder: (context, index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: index.isEven ? scaffoldColor : Colors.white70),
        );
      },
    ),
  );
}