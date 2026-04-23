import 'package:flutter/material.dart';

class MyBox extends StatelessWidget {
  final Widget child;
  const MyBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50), // real shadow color
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 4), // subtle downward shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
