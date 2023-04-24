import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/custom_colors.dart';

class AppNameWidget extends StatelessWidget {
  final Color? mataTitleCor;
  final double textSize;
  const AppNameWidget({
    Key? key,
    this.mataTitleCor,
    this.textSize = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: textSize),
        children: [
          TextSpan(
            text: 'Mata',
            style: TextStyle(
                color: mataTitleCor ?? CustomColors.customSwatchColor),
          ),
          const TextSpan(
            text: 'Fome',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
