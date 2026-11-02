import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/expense_transaction.dart';
import '../models/budget.dart';
import '../firebase_options.dart';

/// Optional Firebase backend. The app continues in offline/local mode if no
/// platform Firebase configuration is present.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();
  bool _ready = false;
  bool get isReady => _ready && Firebase.apps.isNotEmpty;

  Future<bool> initialize() async {
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      if (options.apiKey.startsWith('YOUR_') || options.appId.startsWith('YOUR_') || options.projectId.startsWith('YOUR_')) {
        _ready = false;
        return false;
      }
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: options);
      }
      _ready = Firebase.apps.isNotEmpty;
    } catch (_) {
      _ready = false;
    }
    return _ready;
  }

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  User? get currentUser => isReady ? _auth.currentUser : null;

  Future<String> register(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    return result.user?.email ?? email.trim();
  }

  Future<String> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    return result.user?.email ?? email.trim();
  }

  Future<void> signOut() async { if (isReady) await _auth.signOut(); }

  Future<void> saveTransaction(ExpenseTransaction transaction) async {
    final user = currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('transactions')
        .doc(transaction.id).set(transaction.toJson());
  }

  Future<void> deleteTransaction(String id) async {
    final user = currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('transactions').doc(id).delete();
  }

  Future<void> saveBudget(Budget budget) async {
    final user = currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).collection('budgets')
        .doc(Uri.encodeComponent(budget.category)).set(budget.toJson());
  }

  Future<List<Budget>> fetchBudgets() async {
    final user = currentUser;
    if (user == null) return [];
    final snapshot = await _db.collection('users').doc(user.uid).collection('budgets').get();
    return snapshot.docs.map((d) => Budget.fromJson(d.data())).toList();
  }

  Future<List<ExpenseTransaction>> fetchTransactions() async {
    final user = currentUser;
    if (user == null) return [];
    final snapshot = await _db.collection('users').doc(user.uid).collection('transactions').get();
    return snapshot.docs.map((d) => ExpenseTransaction.fromJson(d.data())).toList();
  }
}
