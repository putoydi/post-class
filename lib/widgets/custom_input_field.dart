import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscure;
  final IconData? prefixIcon;

  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textTheme.labelSmall,
        fillColor: AppColors.textBox,
        filled: true,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.placeholderText) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.textAndOutlines, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.textAndOutlines, width: 1),
        ),
      ),
    );
  }
}
