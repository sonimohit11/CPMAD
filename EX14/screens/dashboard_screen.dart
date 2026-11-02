import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onOpenTransactions});
  final VoidCallback onOpenTransactions;

  String money(double v) => NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2).format(v);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1000 ? 3 : width >= 600 ? 3 : 2;
    final recent = app.transactions.take(5).toList();
    return RefreshIndicator(
      onRefresh: app.refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF5265F2), Color(0xFF7B61FF)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('TOTAL BALANCE', style: TextStyle(color: Colors.white70, letterSpacing: 1.2)),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(money(app.balance), key: ValueKey(app.balance),
                  style: const TextStyle(color: Colors.white, fontSize: 31, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _heroMetric('Income', app.income, Icons.south_west)),
                Expanded(child: _heroMetric('Expenses', app.expenses, Icons.north_east)),
              ]),
            ]),
          ),
          const SizedBox(height: 18),
          GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: width < 400 ? 1.08 : 1.35,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              SummaryCard(title: 'Income', amount: money(app.income), icon: Icons.trending_up, color: Colors.green),
              SummaryCard(title: 'Expenses', amount: money(app.expenses), icon: Icons.trending_down, color: Colors.deepOrange),
              SummaryCard(title: 'Savings', amount: money(app.balance), icon: Icons.savings_outlined, color: Colors.indigo),
            ],
          ),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Recent transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: onOpenTransactions, child: const Text('View all')),
          ]),
          if (app.error != null)
            Card(child: ListTile(leading: const Icon(Icons.error_outline, color: Colors.red), title: Text(app.error!), trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: app.refresh))),
          if (recent.isEmpty)
            const _EmptyDashboard()
          else
            ...recent.map((t) => TransactionTile(
              transaction: t,
              onDelete: () => context.read<AppProvider>().deleteTransaction(t.id),
            )),
          if (app.transactions.isEmpty) const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _heroMetric(String label, double amount, IconData icon) => Row(children: [
    Icon(icon, color: Colors.white, size: 18),
    const SizedBox(width: 8),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white70)),
      Text(money(amount), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ])),
  ]);
}

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard();
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(26),
      child: Column(children: const [
        Icon(Icons.receipt_long_outlined, size: 48, color: Colors.black38),
        SizedBox(height: 10),
        Text('No transactions yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        SizedBox(height: 5),
        Text('Use Add transaction to record your first income or expense.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
      ]),
    ),
  );
}
