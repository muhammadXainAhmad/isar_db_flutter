import 'package:flutter/material.dart';
import 'package:isar_db/utils/colors.dart';

class TileButton extends StatelessWidget {
  final Icon btnIcon;
  final Color bgClr;
  final VoidCallback onPressed;

  const TileButton({super.key, required this.bgClr, required this.btnIcon,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: bgClr,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      onPressed: onPressed,
      icon: btnIcon,
      color: whiteClr,
    );
  }
}
