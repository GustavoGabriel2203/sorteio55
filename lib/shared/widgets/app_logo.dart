import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width = 75,
    this.height = 75,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logoAfinz.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
