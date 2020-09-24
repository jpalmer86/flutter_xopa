import 'package:flutter/material.dart';

class ThemedTextField extends StatelessWidget {
  final String hint;
  final String label;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isPassword;
  final bool multiline;
  final ValueChanged<String> onChanged;

  ThemedTextField({
    this.hint,
    this.label,
    this.errorText,
    this.controller,
    this.textInputType,
    this.isPassword = false,
    this.multiline = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        hintText: hint,
        labelText: label,
        errorText: errorText,
      ),
      controller: controller,
      obscureText: isPassword,
      keyboardType: textInputType ?? (multiline? TextInputType.multiline: null),
      maxLines: multiline? null: 1,
      onChanged: (v) => onChanged?.call(v),
    );
  }
}
