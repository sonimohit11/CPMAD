import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_transaction.dart';
import '../providers/app_provider.dart';
import '../utils/categories.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key, this.transaction});
  final ExpenseTransaction? transaction;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _note;
  late String _category;
  late String _payment;
  late TransactionType _type;
  late DateTime _date;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _title = TextEditingController(text: t?.title ?? '');
    _amount = TextEditingController(text: t?.amount.toString() ?? '');
    _note = TextEditingController(text: t?.note ?? '');
    _type = t?.type ?? TransactionType.expense;
    final categories = _type == TransactionType.income ? incomeCategories : expenseCategories;
    // If an older saved transaction has a category from the wrong type,
    // select a valid category instead of showing an unrelated default.
    _category = t != null && categories.contains(t.category)
        ? t.category
        : (_type == TransactionType.income ? 'Salary' : 'Food');
    _payment = t?.paymentMethod ?? 'Cash';
    _date = t?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _title.dispose(); _amount.dispose(); _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    setState(() => _saving = true);
    final item = ExpenseTransaction(
      id: widget.transaction?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      amount: double.parse(_amount.text.trim()),
      category: _category,
      date: _date,
      type: _type,
      note: _note.text.trim(),
      paymentMethod: _payment,
    );
    try {
      final provider = context.read<AppProvider>();
      if (widget.transaction == null) {
        await provider.addTransaction(item);
      } else {
        await provider.updateTransaction(item);
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save transaction. Please try again.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  List<String> get _availableCategories =>
      _type == TransactionType.income ? incomeCategories : expenseCategories;

  void _changeType(TransactionType nextType) {
    setState(() {
      _type = nextType;
      if (!_availableCategories.contains(_category)) {
        _category = nextType == TransactionType.income ? 'Salary' : 'Food';
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.transaction == null ? 'Add transaction' : 'Edit transaction')),
    body: SafeArea(
      child: Form(
        key: _key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(value: TransactionType.expense, label: Text('Expense'), icon: Icon(Icons.north_east)),
                ButtonSegment(value: TransactionType.income, label: Text('Income'), icon: Icon(Icons.south_west)),
              ],
              selected: {_type},
              onSelectionChanged: (values) => _changeType(values.first),
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _title, textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Title *', prefixIcon: Icon(Icons.edit_outlined)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Enter a transaction title' : null),
            const SizedBox(height: 14),
            TextFormField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount *', prefixText: '₹ '),
              validator: (v) {
                final n = double.tryParse((v ?? '').trim());
                if (n == null || !n.isFinite || n <= 0) return 'Enter an amount greater than zero';
                if (n > 1000000000) return 'Amount is too large';
                return null;
              }),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _availableCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v ?? 'Other'),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _payment,
              decoration: const InputDecoration(labelText: 'Payment method'),
              items: const ['Cash', 'UPI', 'Card', 'Bank transfer', 'Other'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _payment = v ?? 'Cash'),
            ),
            const SizedBox(height: 14),
            Card(child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Transaction date'),
              subtitle: Text('${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}'),
              trailing: const Icon(Icons.edit_calendar),
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (picked != null) setState(() => _date = picked);
              },
            )),
            const SizedBox(height: 14),
            TextFormField(controller: _note, maxLines: 3, maxLength: 200,
              decoration: const InputDecoration(labelText: 'Note (optional)', alignLabelWithHint: true)),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined),
              label: Text(_saving ? 'Saving...' : 'Save transaction'),
            ),
          ],
        ),
      ),
    ),
  );
}
