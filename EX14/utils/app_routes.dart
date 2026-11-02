import 'package:flutter/material.dart';
import '../models/expense_transaction.dart';
import '../screens/app_shell.dart';
import '../screens/transaction_form_screen.dart';

/// Central route table. Use `Navigator.pushNamed(context, AppRoutes.x)`.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const addTransaction = '/transactions/new';
  static const editTransaction = '/transactions/edit';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case addTransaction:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const TransactionFormScreen(),
        );
      case editTransaction:
        final args = settings.arguments;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => TransactionFormScreen(
            transaction: args is ExpenseTransaction ? args : null,
          ),
        );
      case home:
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppShell(),
        );
    }
  }
}
