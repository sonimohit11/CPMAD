import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final credential =
        await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user!.updateDisplayName(name.trim());

    await _db.collection('users').doc(credential.user!.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<String> getRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    return doc.data()?['role'] as String? ?? 'student';
  }
  Future<void> updateProfile({
  required String name,
  required String phone,
}) async {
  final user = _auth.currentUser;

  if (user == null) {
    throw Exception('Please log in first.');
  }

  // Update the Firebase Authentication profile.
  await user.updateDisplayName(name.trim());

  // Update the user's profile in Cloud Firestore.
  await _db.collection('users').doc(user.uid).update({
    'name': name.trim(),
    'phone': phone.trim(),
  });

  // Refresh the local Firebase user information.
  await user.reload();
}
Future<Map<String, dynamic>> getUserProfile(
  String uid,
) async {
  final doc = await _db.collection('users').doc(uid).get();

  return doc.data() ?? {};
}
}