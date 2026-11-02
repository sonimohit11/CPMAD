import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shopping_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingProvider()..initialize(),
      child: const ShoppingApp(),
    ),
  );
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Shopping Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        scaffoldBackgroundColor: const Color(0xFFF8F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F7FB),
          centerTitle: false,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
