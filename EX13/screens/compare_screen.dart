import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_provider.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShoppingProvider>();
    final products = provider.compareProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Products')),
      body: products.length < 2
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  products.isEmpty
                      ? 'Select products using the Compare button on product cards.'
                      : 'Select at least one more product to compare.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('Attribute')),
                  ...products.map((p) => DataColumn(
                    label: SizedBox(width: 150, child: Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis)),
                  )),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Image')),
                    ...products.map((p) => DataCell(SizedBox(width: 100, height: 80,
                      child: Image.network(p.image, fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported))))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Price')),
                    ...products.map((p) => DataCell(Text('\$${p.price.toStringAsFixed(2)}'))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Category')),
                    ...products.map((p) => DataCell(Text(p.category))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Rating')),
                    ...products.map((p) => DataCell(Text('${p.rating} / 5'))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Rating count')),
                    ...products.map((p) => DataCell(Text('${p.ratingCount}'))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Action')),
                    ...products.map((p) => DataCell(TextButton(
                      onPressed: () => provider.toggleCompare(p),
                      child: const Text('Remove'),
                    ))),
                  ]),
                ],
              ),
            ),
    );
  }
}
