import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget.dart';
import '../models/expense_transaction.dart';

class LocalStorageService {
  static const _transactionsKey = 'em_transactions_v2';
  static const _budgetsKey = 'em_budgets_v1';
  static const _userKey = 'em_demo_user_v1';

  Future<List<ExpenseTransaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_transactionsKey);
    if (raw == null) return [];
    final items = jsonDecode(raw) as List<dynamic>;
    return items.map((e) => ExpenseTransaction.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> saveTransactions(List<ExpenseTransaction> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_transactionsKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<List<Budget>> loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_budgetsKey);
    if (raw == null) return [];
    final items = jsonDecode(raw) as List<dynamic>;
    return items.map((e) => Budget.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> saveBudgets(List<Budget> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_budgetsKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<void> saveDemoUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, email);
  }

  Future<String?> loadDemoUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  Future<void> clearDemoUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
