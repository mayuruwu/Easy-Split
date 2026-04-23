import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    required this.hint,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54.withValues(alpha: 0.5)),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
