import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();
  String _paymentMethod = 'Cash on delivery';

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: provider.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Delivery address', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Street address', border: OutlineInputBorder()),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Enter your address' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Enter city' : null,
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: TextFormField(
                      controller: _postalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'PIN code', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Enter PIN code' : null,
                    )),
                  ]),
                  const SizedBox(height: 24),
                  Text('Payment method', style: Theme.of(context).textTheme.titleLarge),
                  RadioListTile<String>(
                    value: 'Cash on delivery',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    title: const Text('Cash on delivery'),
                  ),
                  RadioListTile<String>(
                    value: 'UPI',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    title: const Text('UPI (demo only)'),
                  ),
                  RadioListTile<String>(
                    value: 'Card',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                    title: const Text('Credit/debit card (demo only)'),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Order summary (${provider.cartQuantity} items)',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 10),
                        ...provider.cartItems.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(children: [
                            Expanded(child: Text('${item.product.title} × ${item.quantity}',
                                maxLines: 1, overflow: TextOverflow.ellipsis)),
                            Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                          ]),
                        )),
                        const Divider(height: 24),
                        _summaryRow('Subtotal', provider.subtotal),
                        _summaryRow('Shipping', provider.shipping),
                        const Divider(height: 20),
                        _summaryRow('Total', provider.total, bold: true),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      final orderTotal = provider.total;
                      provider.clearCart();
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Order placed (demo)'),
                          content: Text(
                            'Thank you, ${_nameController.text.trim()}!\\n'
                            'Total: \$${orderTotal.toStringAsFixed(2)}\\n'
                            'Payment: $_paymentMethod\\n\\n'
                            'This is a demo checkout. No real payment was processed.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                Navigator.pop(context);
                              },
                              child: const Text('Done'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('Place order'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _summaryRow(String label, double amount, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text('\$${amount.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    ]),
  );
}
