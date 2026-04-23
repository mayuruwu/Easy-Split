import 'package:flutter/material.dart';
import 'package:easy_split/ui/elements/app_bar.dart';
import 'package:easy_split/ui/elements/googlebutton.dart';

class LoginPage extends StatelessWidget {
  final String? errormessage;

  const LoginPage({super.key, this.errormessage});
  @override
  Widget build(BuildContext context) {
    if (errormessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ $errormessage :("),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      });
    }

    return Scaffold(
      appBar: myAppBar(title: "Easy Split"),
      body: Stack(
        children: [
          SizedBox.expand(child: Container(color: Colors.black87)),

          Column(
            children: [
              Spacer(flex: 1),
              SizedBox(
                child: Image.asset(
                  'assets/images/NMK1.png',
                  fit: BoxFit.contain,
                ),
              ),
              // Spacer(flex: 1),
              Center(child: Googlebutton()),
              Spacer(flex: 4),
            ],
          ),
        ],
      ),
    );
  }
}
