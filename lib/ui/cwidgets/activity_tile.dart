import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool? positive;

  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.positive,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (positive == null) {
      color = Colors.grey;
    } else {
      color = positive! ? Colors.green : Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 10),

          /// text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
