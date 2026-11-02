import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../utils/app_routes.dart';
import 'auth_screen.dart';
import 'dashboard_screen.dart';
import 'transactions_screen.dart';
import 'budgets_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    if (app.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!app.isSignedIn) return const AuthScreen();

    final pages = <Widget>[
      DashboardScreen(onOpenTransactions: () => setState(() => _index = 1)),
      const TransactionsScreen(),
      const BudgetsScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];
    final titles = ['Dashboard', 'Transactions', 'Budgets', 'Reports', 'Settings'];

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 760;
      return Scaffold(
        appBar: AppBar(
          title: Text(titles[_index], style: const TextStyle(fontWeight: FontWeight.w800)),
          actions: [
            IconButton(
              tooltip: app.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
              onPressed: app.toggleDarkMode,
              icon: Icon(app.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            ),
            IconButton(
              tooltip: 'Add transaction',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addTransaction),
              icon: const Icon(Icons.add_circle_outline),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(children: [
          if (app.error != null)
            MaterialBanner(
              content: Text(app.error!),
              leading: const Icon(Icons.warning_amber_rounded),
              actions: [TextButton(onPressed: app.refresh, child: const Text('Retry'))],
            ),
          Expanded(child: Row(children: [
            if (wide) NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (v) => setState(() => _index = v),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Home')),
                NavigationRailDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: Text('Transactions')),
                NavigationRailDestination(icon: Icon(Icons.savings_outlined), selectedIcon: Icon(Icons.savings), label: Text('Budgets')),
                NavigationRailDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: Text('Reports')),
                NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
              ],
            ),
            Expanded(child: IndexedStack(index: _index, children: pages)),
          ])),
        ]),
        floatingActionButton: _index == 0 || _index == 1
            ? FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addTransaction),
                icon: const Icon(Icons.add),
                label: const Text('Add transaction'),
              )
            : null,
        bottomNavigationBar: wide ? null : NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (v) => setState(() => _index = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'History'),
            NavigationDestination(icon: Icon(Icons.savings_outlined), selectedIcon: Icon(Icons.savings), label: 'Budgets'),
            NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Reports'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      );
    });
  }
}
