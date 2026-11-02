import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/shopping_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingProvider>();
    final inCart = provider.isInCart(product.id);
    final wished = provider.isWishlisted(product.id);
    final compared = provider.isCompared(product.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Center(
                          child: Icon(Icons.image_not_supported_outlined, size: 42),
                        ),
                        loadingBuilder: (context, child, progress) => progress == null
                            ? child
                            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      tooltip: wished ? 'Remove from wishlist' : 'Add to wishlist',
                      onPressed: () => context.read<ShoppingProvider>().toggleWishlist(product),
                      icon: Icon(wished ? Icons.favorite : Icons.favorite_border,
                          color: wished ? Colors.red : null),
                    ),
                  ),
                ],
              ),
            ),
            Text(product.category.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 5),
            Text(product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                Text(' ${product.rating.toStringAsFixed(1)}'),
                const Spacer(),
                Text('\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => context.read<ShoppingProvider>().toggleCompare(product),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                    child: Text(compared ? 'Selected' : 'Compare', maxLines: 1),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.read<ShoppingProvider>().addToCart(product),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                    child: Icon(inCart ? Icons.add_shopping_cart : Icons.shopping_cart_outlined, size: 19),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
