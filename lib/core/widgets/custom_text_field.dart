import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Function(String value)? onChanged;
  final bool isPassword;
  final TextInputType? keyboardType;
  final bool showLabel;
  final String? prefixIconPath;
  final double? prefixIconPadding;
  final Widget? suffixIcon;
  final bool readOnly;
  final int maxLines;
  final bool isRequired;
  final Color? iconColor;
  final TextStyle? labelStyle;
  final double spaceContent;
  final bool enabled;
  final String? fieldId;
  final List<String? Function(String?)>? validators;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.onChanged,
    this.isPassword = false,
    this.keyboardType,
    this.showLabel = true,
    this.prefixIconPath,
    this.prefixIconPadding,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.isRequired = true,
    this.iconColor,
    this.labelStyle,
    this.spaceContent = 12.0,
    this.enabled = true,
    this.fieldId,
    this.validators,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: widget.labelStyle ??
                TextStyle(
                  fontSize: 14.0,
                  color: AppColors.blackColor,
                ),
          ),
        ],
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: widget.isPassword,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          scrollPadding: EdgeInsets.all(200),
          decoration: InputDecoration(
            enabled: widget.enabled,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.visibility_off,
                        color: AppColors.neutral13Color),
                  )
                : widget.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.neutral10Color),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.neutral10Color),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            hintText: widget.hintText,
          ),
          validator: widget.isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return '${widget.label} cannot be empty';
                  }
                  if (widget.validators != null) {
                    for (final validator in widget.validators!) {
                      final error = validator(value);
                      if (error != null) {
                        return error;
                      }
                    }
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
