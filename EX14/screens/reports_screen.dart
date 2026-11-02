import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../models/expense_transaction.dart';
import '../providers/app_provider.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final expenses = app.transactions.where((t) => t.type == TransactionType.expense).toList();
    final byCategory = <String, double>{};
    for (final t in expenses) {
      byCategory[t.category] = (byCategory[t.category] ?? 0) + t.amount;
    }
    final entries = byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = entries.isEmpty ? 1.0 : entries.first.value * 1.15;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      children: [
        const Text('Financial overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('A summary calculated from your saved transactions.', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _stat('Income', app.income, Colors.green)),
          const SizedBox(width: 10),
          Expanded(child: _stat('Expenses', app.expenses, Colors.deepOrange)),
        ]),
        const SizedBox(height: 18),
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Spending by category', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (entries.isEmpty)
              const SizedBox(height: 160, child: Center(child: Text('Add expenses to see your chart.')))
            else
              SizedBox(
                height: 220,
                child: BarChart(BarChartData(
                  maxY: maxValue,
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 42)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= entries.length) return const SizedBox.shrink();
                        final label = entries[i].key;
                        return Padding(padding: const EdgeInsets.only(top: 8), child: Text(label.length > 6 ? label.substring(0, 6) : label, style: const TextStyle(fontSize: 10)));
                      },
                    )),
                  ),
                  barGroups: List.generate(entries.length, (i) => BarChartGroupData(x: i, barRods: [
                    BarChartRodData(toY: entries[i].value, width: 18, borderRadius: BorderRadius.circular(5), color: const Color(0xFF5265F2)),
                  ])),
                ), swapAnimationDuration: const Duration(milliseconds: 400)),
              ),
          ]),
        )),
        const SizedBox(height: 14),
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Category breakdown', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (entries.isEmpty) const Text('No category data available yet.')
            else ...entries.map((e) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.key),
              trailing: Text('₹${e.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
          ]),
        )),
      ],
    );
  }

  Widget _stat(String title, double amount, Color color) => Card(
    child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 8),
      FittedBox(child: Text('₹${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 21, color: color, fontWeight: FontWeight.bold))),
    ])),
  );
}
