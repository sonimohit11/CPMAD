import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ShoppingProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  static const String _cartStorageKey = 'shopping_cart_v1';

  List<Product> _products = [];
  List<String> _categories = [];
  final Map<int, CartItem> _cart = {};
  final Set<int> _wishlist = {};
  final Set<int> _compare = {};

  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _initialized = false;

  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => ['All', ..._categories];
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get initialized => _initialized;
  List<CartItem> get cartItems => List.unmodifiable(_cart.values);
  List<Product> get wishlistProducts =>
      _products.where((p) => _wishlist.contains(p.id)).toList();
  List<Product> get compareProducts =>
      _products.where((p) => _compare.contains(p.id)).toList();
  int get cartQuantity =>
      _cart.values.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal =>
      _cart.values.fold(0.0, (sum, item) => sum + item.lineTotal);
  double get shipping => _cart.isEmpty || subtotal >= 100 ? 0 : 5.99;
  double get total => subtotal + shipping;
  bool isInCart(int id) => _cart.containsKey(id);
  bool isWishlisted(int id) => _wishlist.contains(id);
  bool isCompared(int id) => _compare.contains(id);
  int quantityFor(int id) => _cart[id]?.quantity ?? 0;

  List<Product> get filteredProducts {
    final query = _searchQuery.trim().toLowerCase();
    return _products.where((product) {
      final matchesSearch = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await loadProducts();
    await _restoreCart();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _api.fetchProducts();
      try {
        _categories = await _api.fetchCategories();
      } catch (_) {
        _categories = _products.map((p) => p.category).toSet().toList()..sort();
      }
      _categories = _categories.toSet().toList()..sort();
      _selectedCategory = 'All';
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    if (_cart.containsKey(product.id)) {
      _cart[product.id]!.quantity++;
    } else {
      _cart[product.id] = CartItem(product: product);
    }
    await _saveCart();
    notifyListeners();
  }

  Future<void> decreaseQuantity(int productId) async {
    final item = _cart[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      _cart.remove(productId);
    } else {
      item.quantity--;
    }
    await _saveCart();
    notifyListeners();
  }

  Future<void> removeFromCart(int productId) async {
    _cart.remove(productId);
    await _saveCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cart.clear();
    await _saveCart();
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (!_wishlist.add(product.id)) _wishlist.remove(product.id);
    notifyListeners();
  }

  void toggleCompare(Product product) {
    if (_compare.contains(product.id)) {
      _compare.remove(product.id);
    } else if (_compare.length < 4) {
      _compare.add(product.id);
    }
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_cart.values.map((item) => item.toJson()).toList());
    await prefs.setString(_cartStorageKey, encoded);
  }

  Future<void> _restoreCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartStorageKey);
    if (raw == null || _products.isEmpty) return;
    try {
      final saved = jsonDecode(raw) as List<dynamic>;
      for (final entry in saved) {
        final map = entry as Map<String, dynamic>;
        final productId = (map['productId'] as num).toInt();
        final quantity = (map['quantity'] as num).toInt();
        final matches = _products.where((p) => p.id == productId);
        if (matches.isNotEmpty && quantity > 0) {
          _cart[productId] = CartItem(product: matches.first, quantity: quantity);
        }
      }
      notifyListeners();
    } catch (_) {
      await prefs.remove(_cartStorageKey);
    }
  }
}
