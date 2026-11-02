import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'compare_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopEase', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Compare products',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompareScreen())),
            icon: Badge(
              label: Text('${provider.compareProducts.length}'),
              isLabelVisible: provider.compareProducts.isNotEmpty,
              child: const Icon(Icons.compare_arrows),
            ),
          ),
          IconButton(
            tooltip: 'Wishlist',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen())),
            icon: Badge(
              label: Text('${provider.wishlistProducts.length}'),
              isLabelVisible: provider.wishlistProducts.isNotEmpty,
              child: const Icon(Icons.favorite_border),
            ),
          ),
          IconButton(
            tooltip: 'Cart',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
            icon: Badge(
              label: Text('${provider.cartQuantity}'),
              isLabelVisible: provider.cartQuantity > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, ShoppingProvider provider) {
    if (provider.isLoading && provider.products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null && provider.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off, size: 56),
            const SizedBox(height: 12),
            Text(provider.error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: provider.loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ]),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadProducts,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Find your next favorite',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  onChanged: provider.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];
                      final selected = provider.selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category == 'All' ? 'All products' : _titleCase(category)),
                        selected: selected,
                        onSelected: (_) => provider.setCategory(category),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
          if (provider.filteredProducts.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No products match your search.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCard(product: provider.filteredProducts[index]),
                  childCount: provider.filteredProducts.length,
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.57,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _titleCase(String value) => value
      .split(' ')
      .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
