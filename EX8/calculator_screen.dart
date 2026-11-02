
import 'package:flutter/material.dart';
import 'app_localizations.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final firstController = TextEditingController();
  final secondController = TextEditingController();

  String operation = 'addition';
  String result = '';

  void calculate() {
    final app = AppLocalizations.of(context);
    final a = double.tryParse(firstController.text);
    final b = double.tryParse(secondController.text);

    if (a == null || b == null) {
      setState(() => result = app.text('error'));
      return;
    }

    double answer;

    switch (operation) {
      case 'subtraction':
        answer = a - b;
        break;
      case 'multiplication':
        answer = a * b;
        break;
      case 'division':
        if (b == 0) {
          setState(() => result = app.text('error'));
          return;
        }
        answer = a / b;
        break;
      default:
        answer = a + b;
    }

    setState(() {
      result = '${app.text('result')}: ${answer.toStringAsFixed(2)}';
    });
  }

  void clearFields() {
    firstController.clear();
    secondController.clear();
    setState(() => result = '');
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(app.text('calculator'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: firstController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: InputDecoration(
              labelText: app.text('enterNumber') + ' 1',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: secondController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: InputDecoration(
              labelText: app.text('enterNumber') + ' 2',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: operation,
            decoration: InputDecoration(
              labelText: app.text('calculator'),
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: 'addition',
                child: Text(app.text('addition')),
              ),
              DropdownMenuItem(
                value: 'subtraction',
                child: Text(app.text('subtraction')),
              ),
              DropdownMenuItem(
                value: 'multiplication',
                child: Text(app.text('multiplication')),
              ),
              DropdownMenuItem(
                value: 'division',
                child: Text(app.text('division')),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => operation = value);
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: calculate,
            child: Text(app.text('calculate')),
          ),
          OutlinedButton(
            onPressed: clearFields,
            child: Text(app.text('clear')),
          ),
          const SizedBox(height: 20),
          SelectableText(
            result,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
