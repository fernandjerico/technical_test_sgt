import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum ButtonStyleType { filled, outlined }

class Button extends StatelessWidget {
  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.filled,
    this.color = AppColors.primaryColor,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 36.0,
    this.borderRadius = 30.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w400,
    this.borderColor = AppColors.primaryColor,
  });

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.outlined,
    this.color = Colors.transparent,
    this.textColor = AppColors.primaryColor,
    this.width = double.infinity,
    this.height = 36.0,
    this.borderRadius = 30.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.w400,
    this.borderColor = AppColors.primaryColor,
  });

  final Function() onPressed;
  final String label;
  final ButtonStyleType style;
  final Color color;
  final Color textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool disabled;
  final double fontSize;
  final FontWeight fontWeight;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: style == ButtonStyleType.filled
          ? ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox.shrink(),
                  if (icon != null && label.isNotEmpty)
                    const SizedBox(width: 10.0),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                  if (suffixIcon != null && label.isNotEmpty)
                    const SizedBox(width: 10.0),
                  suffixIcon ?? const SizedBox.shrink(),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: color,
                side: BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon ?? const SizedBox.shrink(),
                  if (icon != null && label.isNotEmpty)
                    const SizedBox(width: 10.0),
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                  if (suffixIcon != null && label.isNotEmpty)
                    const SizedBox(width: 10.0),
                  suffixIcon ?? const SizedBox.shrink(),
                ],
              ),
            ),
    );
  }
}
