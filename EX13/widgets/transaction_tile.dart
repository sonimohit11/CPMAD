import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onDelete, this.onEdit});
  final ExpenseTransaction transaction;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color = isIncome ? Colors.green : Colors.deepOrange;
    return Card(
      margin: const EdgeInsets.only(bottom: 9),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .12),
          child: Icon(_iconFor(transaction.category), color: color),
        ),
        title: Text(transaction.title, maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${transaction.category} • ${DateFormat('d MMM yyyy').format(transaction.date)}'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          Text('${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit?.call();
              if (value == 'delete') onDelete?.call();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ]),
      ),
    );
  }

  IconData _iconFor(String category) => switch (category) {
    'Food' => Icons.restaurant,
    'Travel' => Icons.directions_bus,
    'Shopping' => Icons.shopping_bag,
    'Bills' => Icons.receipt_long,
    'Salary' => Icons.payments,
    'Health' => Icons.health_and_safety,
    'Education' => Icons.school,
    _ => Icons.category,
  };
}
