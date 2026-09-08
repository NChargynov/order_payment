import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order_payment/core/theme/app_styles.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.focusNode,
    this.errorText,
    this.prefixIcon,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final FocusNode? focusNode;
  final String? errorText;
  final Widget? prefixIcon;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTapOutside: (_) => focusNode?.unfocus(),
      textInputAction: TextInputAction.done,
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: AppColors.textPrimary,
      style: AppStyles.smallMedium.copyWith(fontSize: 14),
      decoration: InputDecoration(
        hintText: label,
        isDense: true,
        hintStyle: AppStyles.smallMedium.copyWith(fontSize: 14),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(
          12
        ),
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        errorText: errorText,
        errorMaxLines: 3,
        errorStyle: AppStyles.smallSemiBold.copyWith(color: AppColors.error),
      ),
    );
  }
}
