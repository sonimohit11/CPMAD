import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.title, required this.amount, required this.icon, required this.color});
  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(backgroundColor: color.withValues(alpha: .12), child: Icon(icon, color: color)),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 4),
        FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft,
          child: Text(amount, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
      ]),
    ),
  );
}
