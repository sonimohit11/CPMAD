import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products'))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Server returned status ${response.statusCode}.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected response from the product API.');
    }

    return decoded
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/products/categories'))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Could not load categories.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) return [];
    return decoded.map((item) => item.toString()).toList();
  }
}
