import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingProvider>();
    final products = provider.wishlistProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: products.isEmpty
          ? const Center(child: Text('Your wishlist is empty. Tap the heart on a product to save it.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: ListTile(
                    leading: SizedBox(width: 54, height: 54,
                      child: Image.network(product.image, fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported))),
                    title: Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        tooltip: 'Add to cart',
                        onPressed: () => provider.addToCart(product),
                        icon: const Icon(Icons.add_shopping_cart),
                      ),
                      IconButton(
                        tooltip: 'Remove from wishlist',
                        onPressed: () => provider.toggleWishlist(product),
                        icon: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
