import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget.dart';
import '../providers/app_provider.dart';
import '../utils/categories.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  Future<void> _addBudget(BuildContext context) async {
    final key = GlobalKey<FormState>();
    final amount = TextEditingController();
    String category = 'Food';
    final result = await showDialog<Budget>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) => AlertDialog(
        title: const Text('Set monthly budget'),
        content: Form(
          key: key,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: expenseCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => category = v ?? 'Food'),
            ),
            const SizedBox(height: 12),
            TextFormField(controller: amount, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monthly limit (₹)'),
              validator: (v) { final n = double.tryParse(v ?? ''); return n == null || n <= 0 ? 'Enter a positive limit' : null; }),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (key.currentState!.validate()) Navigator.pop(context, Budget(category: category, limit: double.parse(amount.text)));
          }, child: const Text('Save')),
        ],
      )),
    );
    // The controller is left for GC: disposing here races the dialog's exit animation.
    if (result != null && context.mounted) await context.read<AppProvider>().saveBudget(result);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      children: [
        const Text('Monthly spending limits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('Set category limits and track how much you have spent.',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () => _addBudget(context), icon: const Icon(Icons.add), label: const Text('Add or update budget')),
        const SizedBox(height: 12),
        if (app.budgets.isEmpty)
          Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
            Icon(Icons.savings_outlined, size: 44, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 10),
            const Text('No budgets set yet', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Create a budget to monitor category spending.', textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ])))
        else
          ...app.budgets.map((b) {
            final spent = app.spentForCategory(b.category);
            final ratio = (spent / b.limit).clamp(0.0, 1.0);
            final exceeded = spent > b.limit;
            return Card(
              child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(b.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  Text('₹${spent.toStringAsFixed(0)} / ₹${b.limit.toStringAsFixed(0)}',
                    style: TextStyle(color: exceeded ? Colors.red : Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 12),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: ratio),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value, minHeight: 9, borderRadius: BorderRadius.circular(8),
                    color: exceeded ? Colors.red : const Color(0xFF5265F2),
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 8),
                Text(exceeded ? 'Budget exceeded' : '${(ratio * 100).round()}% used',
                  style: TextStyle(color: exceeded ? Colors.red : Theme.of(context).colorScheme.onSurfaceVariant)),
              ])),
            );
          }),
      ],
    );
  }
}
