import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final String? title;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final double borderRadius;
  final double paddingVertical;
  final double paddingHorizontal;

  const AppButton({
    required this.text,
    this.title,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.borderRadius = 12.0,
    this.paddingVertical = 14.0,
    this.paddingHorizontal = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final defaultButtonColor = buttonColor ?? Appcolors.primary;
    final defaultTextColor = textColor ?? Appcolors.accent;

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: defaultTextColor,
          backgroundColor: defaultButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(
            vertical: paddingVertical,
            horizontal: paddingHorizontal,
          ),
        ),
        child: Column(
          children: [
            title != null
                ? Text(
                    title!,
                    style: TextStyle(
                      fontSize: 10,
                      color: defaultTextColor,
                    ),
                  )
                : SizedBox(),
            Text(
              text,
              style: TextStyle(color: defaultTextColor, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
