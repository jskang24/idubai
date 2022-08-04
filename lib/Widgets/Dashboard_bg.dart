import 'package:flutter/material.dart';

// H

class ContainerTwoColours extends StatelessWidget {
  final Color backgroundColor;
  final Color progressColor;
  final double progress;
  final double widthSize;
  final double heightSize;

  const ContainerTwoColours({
    this.backgroundColor = const Color.fromARGB(255, 113, 180, 231),
    this.progressColor = Colors.white,
    required this.progress,
    required this.widthSize,
    required this.heightSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        height: heightSize,
        width: widthSize,
        child: Stack(
          children: [
            Container(
              color: backgroundColor,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: heightSize * progress,
                color: progressColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
