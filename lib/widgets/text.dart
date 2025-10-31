import 'package:flutter/material.dart';

class BuildText extends StatelessWidget {
  final String text;
  final Color textClr;
  final double textSize;
  final FontWeight textWeight;
  

  const BuildText({
    super.key,
    required this.text,
    required this.textClr,
    required this.textSize,
    required this.textWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textClr,
        fontSize: textSize,
        fontWeight: textWeight,
        inherit: true
      ),
    );
  }
}
