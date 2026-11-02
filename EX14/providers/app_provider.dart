import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/budget.dart';
import '../models/expense_transaction.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';
import '../services/firebase_service.dart';
import '../utils/categories.dart';

final _incomeCategories = incomeCategories.toSet();
final _expenseCategories = expenseCategories.toSet();

String _safeCategory(ExpenseTransaction transaction) {
  final allowed = transaction.type == TransactionType.income ? _incomeCategories : _expenseCategories;
  if (allowed.contains(transaction.category)) return transaction.category;
  return transaction.type == TransactionType.income ? 'Salary' : 'Other';
}

class AppProvider extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  final List<ExpenseTransaction> _transactions = [];
  final List<Budget> _budgets = [];
  bool _loading = true;
  String? _error;
  String? _userEmail;

  List<ExpenseTransaction> get transactions => List.unmodifiable(_transactions);
  List<Budget> get budgets => List.unmodifiable(_budgets);
  bool get isLoading => _loading;
  String? get error => _error;
  String? get userEmail => _userEmail;
  bool get isSignedIn => _userEmail != null;
  bool get isCloudSession => FirebaseService.instance.isReady && FirebaseService.instance.currentUser != null;

  double get income => _transactions.where((t) => t.type == TransactionType.income).fold(0, (s, t) => s + t.amount);
  double get expenses => _transactions.where((t) => t.type == TransactionType.expense).fold(0, (s, t) => s + t.amount);
  double get balance => income - expenses;

  /// Reload data without replacing the screen with a full-page spinner.
  Future<void> refresh() => initialize(showSpinner: false);

  Future<void> initialize({bool showSpinner = true}) async {
    if (showSpinner) {
      _loading = true;
      notifyListeners();
    }
    try {
      _transactions
        ..clear()
        ..addAll(await _storage.loadTransactions());
      _budgets
        ..clear()
        ..addAll(await _storage.loadBudgets());
      _userEmail = FirebaseService.instance.currentUser?.email ?? await _storage.loadDemoUser();
      if (FirebaseService.instance.isReady && FirebaseService.instance.currentUser != null) {
        try {
          final cloudItems = await FirebaseService.instance.fetchTransactions();
          if (cloudItems.isNotEmpty) {
            _transactions..clear()..addAll(cloudItems);
            await _storage.saveTransactions(_transactions);
          }
          final cloudBudgets = await FirebaseService.instance.fetchBudgets();
          if (cloudBudgets.isNotEmpty) {
            _budgets..clear()..addAll(cloudBudgets);
            await _storage.saveBudgets(_budgets);
          }
        } catch (_) { /* Keep local data available offline. */ }
      }
      _error = null;
    } catch (_) {
      _error = 'Saved data could not be loaded. Please restart the app and try again.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ExpenseTransaction _withSafeCategory(ExpenseTransaction t) => ExpenseTransaction(
    id: t.id, title: t.title, amount: t.amount, category: _safeCategory(t),
    date: t.date, type: t.type, note: t.note, paymentMethod: t.paymentMethod,
  );

  Future<void> addTransaction(ExpenseTransaction transaction) async {
    transaction = _withSafeCategory(transaction);
    _transactions.insert(0, transaction);
    await _persistTransactions();
    try { await FirebaseService.instance.saveTransaction(transaction); } catch (_) { /* Offline-first: local copy remains saved. */ }
    if (transaction.type == TransactionType.expense) {
      final budget = _budgets.where((b) => b.category == transaction.category).firstOrNull;
      if (budget != null) {
        final spent = spentForCategory(transaction.category);
        if (spent >= budget.limit) {
          await NotificationService.instance.showBudgetAlert(transaction.category, spent, budget.limit);
        }
      }
    }
    notifyListeners();
  }

  Future<void> updateTransaction(ExpenseTransaction transaction) async {
    transaction = _withSafeCategory(transaction);
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index >= 0) {
      _transactions[index] = transaction;
      await _persistTransactions();
      try { await FirebaseService.instance.saveTransaction(transaction); } catch (_) { /* Sync retries when edited online. */ }
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await _persistTransactions();
    try { await FirebaseService.instance.deleteTransaction(id); } catch (_) { /* Keep local delete while offline. */ }
    notifyListeners();
  }

  Future<void> saveBudget(Budget budget) async {
    final index = _budgets.indexWhere((b) => b.category == budget.category);
    if (index >= 0) {
      _budgets[index] = budget;
    } else {
      _budgets.add(budget);
    }
    await _storage.saveBudgets(_budgets);
    try { await FirebaseService.instance.saveBudget(budget); } catch (_) { /* Local budget remains available offline. */ }
    notifyListeners();
  }

  double spentForCategory(String category) => _transactions
      .where((t) => t.type == TransactionType.expense && t.category == category && t.date.month == DateTime.now().month && t.date.year == DateTime.now().year)
      .fold(0, (sum, t) => sum + t.amount);

  Future<void> signInDemo(String email, String password, {bool register = false}) async {
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      throw const FormatException('Enter a valid email address.');
    }
    if (password.length < 6) throw const FormatException('Password must be at least 6 characters.');
    if (FirebaseService.instance.isReady) {
      try {
        _userEmail = register
            ? await FirebaseService.instance.register(email, password)
            : await FirebaseService.instance.signIn(email, password);
        try {
          final cloudItems = await FirebaseService.instance.fetchTransactions();
          if (cloudItems.isNotEmpty) {
            _transactions..clear()..addAll(cloudItems);
            await _storage.saveTransactions(_transactions);
          }
          final cloudBudgets = await FirebaseService.instance.fetchBudgets();
          if (cloudBudgets.isNotEmpty) {
            _budgets..clear()..addAll(cloudBudgets);
            await _storage.saveBudgets(_budgets);
          }
        } catch (_) { /* Local data remains usable if cloud fetch fails. */ }
      } on FirebaseAuthException catch (e) {
        throw FormatException(e.message ?? 'Authentication failed (${e.code}).');
      }
    } else {
      // Fully usable offline/demo mode when Firebase credentials are not configured.
      _userEmail = email.trim();
      await _storage.saveDemoUser(_userEmail!);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try { await FirebaseService.instance.signOut(); } catch (_) {}
    _userEmail = null;
    await _storage.clearDemoUser();
    notifyListeners();
  }

  Future<void> _persistTransactions() async {
    try {
      await _storage.saveTransactions(_transactions);
      _error = null;
    } catch (_) {
      _error = 'Could not save data locally.';
    }
  }

  List<ExpenseTransaction> filteredTransactions({
    String query = '',
    String category = 'All',
    String type = 'All',
    DateTime? from,
    DateTime? to,
    double? minAmount,
    double? maxAmount,
  }) {
    return _transactions.where((t) {
      final matchesQuery = t.title.toLowerCase().contains(query.toLowerCase()) ||
          t.category.toLowerCase().contains(query.toLowerCase()) ||
          t.note.toLowerCase().contains(query.toLowerCase());
      final matchesCategory = category == 'All' || t.category == category;
      final matchesType = type == 'All' || t.type.name == type.toLowerCase();
      final matchesFrom = from == null || !t.date.isBefore(DateTime(from.year, from.month, from.day));
      final matchesTo = to == null || !t.date.isAfter(DateTime(to.year, to.month, to.day, 23, 59, 59));
      final matchesMin = minAmount == null || t.amount >= minAmount;
      final matchesMax = maxAmount == null || t.amount <= maxAmount;
      return matchesQuery && matchesCategory && matchesType && matchesFrom && matchesTo && matchesMin && matchesMax;
    }).toList();
  }
}
