import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "TOTAL BALANCE",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        SizedBox(height: 5),
        Text(
          "\$1,240.50",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
