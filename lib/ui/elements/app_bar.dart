import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar myAppBar({
  required String title,
  List<Widget>? actions,
  bool backButton = false,
}) {
  return AppBar(
    leading: backButton ? BackButton() : null,
    title: Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      textScaler: TextScaler.linear(0.95),
    ),
    centerTitle: true,
    actions: actions != null ? (actions..add(const SizedBox(width: 10))) : [],
  );
}
