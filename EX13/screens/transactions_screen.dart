import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/transaction_tile.dart';
import '../utils/app_routes.dart';
import '../utils/categories.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _search = TextEditingController();
  String _category = 'All';
  String _type = 'All';
  DateTime? _from;
  DateTime? _to;
  final _min = TextEditingController();
  final _max = TextEditingController();

  @override
  void dispose() {
    _search.dispose(); _min.dispose(); _max.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final items = provider.filteredTransactions(
      query: _search.text,
      category: _category,
      type: _type,
      from: _from,
      to: _to,
      minAmount: double.tryParse(_min.text),
      maxAmount: double.tryParse(_max.text),
    );
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        child: TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search title, category or note',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _search.text.isEmpty ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () { _search.clear(); setState(() {}); }),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: const Text('Advanced filters'),
          subtitle: const Text('Category, type, date and amount'),
          children: [
            Row(children: [
              Expanded(child: DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['All', ...allCategories]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _category = v ?? 'All'),
              )),
              const SizedBox(width: 10),
              Expanded(child: DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const ['All', 'Income', 'Expense'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _type = v ?? 'All'),
              )),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                icon: const Icon(Icons.date_range),
                label: Text(_from == null ? 'From date' : '${_from!.day}/${_from!.month}/${_from!.year}'),
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: _from ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)));
                  if (d != null) setState(() => _from = d);
                },
              )),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton.icon(
                icon: const Icon(Icons.event),
                label: Text(_to == null ? 'To date' : '${_to!.day}/${_to!.month}/${_to!.year}'),
                onPressed: () async {
                  final d = await showDatePicker(context: context, initialDate: _to ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)));
                  if (d != null) setState(() => _to = d);
                },
              )),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: TextField(controller: _min, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Min amount'))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _max, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Max amount'))),
            ]),
            Align(alignment: Alignment.centerRight, child: TextButton(
              onPressed: () => setState(() { _category = 'All'; _type = 'All'; _from = null; _to = null; _min.clear(); _max.clear(); _search.clear(); }),
              child: const Text('Clear all filters'),
            )),
          ],
        ),
      ),
      const SizedBox(height: 4),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Align(
        alignment: Alignment.centerLeft,
        child: Text('${items.length} transaction(s)', style: const TextStyle(color: Colors.black54)),
      )),
      const SizedBox(height: 8),
      Expanded(child: items.isEmpty
        ? const _EmptyTransactions()
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return TransactionTile(
                transaction: item,
                onDelete: () => context.read<AppProvider>().deleteTransaction(item.id),
                onEdit: () => Navigator.of(context).pushNamed(AppRoutes.editTransaction, arguments: item),
              );
            },
          )),
    ]);
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.search_off, size: 48, color: Colors.black38),
        SizedBox(height: 12),
        Text('No matching transactions', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        Text('Try changing your filters or add a transaction.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
      ]),
    ),
  );
}
