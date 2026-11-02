import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      // Local demo authentication is used until Firebase is configured.
      await context.read<AppProvider>().signInDemo(_email.text, _password.text, register: _register);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('FormatException: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: app.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: app.toggleDarkMode,
            icon: Icon(app.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  const CircleAvatar(radius: 34, child: Icon(Icons.account_balance_wallet, size: 34)),
                  const SizedBox(height: 18),
                  Text(_register ? 'Create your account' : 'Welcome back',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Track your money with clarity.', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  TextFormField(controller: _email, keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined)),
                    validator: (v) => v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim()) ? 'Enter a valid email' : null),
                  const SizedBox(height: 14),
                  TextFormField(controller: _password, obscureText: _obscure,
                    decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off))),
                    validator: (v) => v == null || v.length < 6 ? 'Use at least 6 characters' : null),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_register ? 'Create account' : 'Sign in'),
                  ),
                  TextButton(
                    onPressed: () => setState(() { _register = !_register; _error = null; }),
                    child: Text(_register ? 'Already have an account? Sign in' : 'New here? Create an account'),
                  ),
                  const SizedBox(height: 8),
                  Text('Firebase authentication is used when configured. Otherwise, the app runs in local demo mode.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ]),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
