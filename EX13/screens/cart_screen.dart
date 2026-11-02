import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: provider.cartItems.isEmpty
          ? const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('Your cart is empty'),
                SizedBox(height: 4),
                Text('Add a few products to get started.'),
              ]),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...provider.cartItems.map((item) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(children: [
                      SizedBox(
                        width: 76,
                        height: 76,
                        child: Image.network(item.product.image, fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.product.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        Text('\$${item.product.price.toStringAsFixed(2)} each'),
                        const SizedBox(height: 5),
                        Text('Line total: \$${item.lineTotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                      Column(children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => provider.decreaseQuantity(item.product.id),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => provider.addToCart(item.product),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ]),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Remove item',
                          onPressed: () => provider.removeFromCart(item.product.id),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ]),
                    ]),
                  ),
                )),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      _priceRow('Items (${provider.cartQuantity})', provider.subtotal),
                      const SizedBox(height: 8),
                      _priceRow('Shipping', provider.shipping),
                      const Divider(height: 24),
                      _priceRow('Total', provider.total, bold: true),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                          icon: const Icon(Icons.lock_outline),
                          label: const Text('Proceed to checkout'),
                        ),
                      ),
                    ]),
                  ),
                ),
                TextButton(
                  onPressed: provider.clearCart,
                  child: const Text('Clear cart'),
                ),
              ],
            ),
    );
  }

  Widget _priceRow(String label, double amount, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text('\$${amount.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: bold ? 18 : 14)),
    ],
  );
}
