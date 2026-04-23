import 'package:flutter/material.dart';
import 'package:easy_split/ui/elements/mybox.dart';

void showWelcomePopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Welcome",
    transitionDuration: Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: MyBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/welcome.jpg',
                  height: 400,
                  width: 400,
                ),
              ),
              MyBox(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Continue", textScaler: TextScaler.linear(1.50)),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}
