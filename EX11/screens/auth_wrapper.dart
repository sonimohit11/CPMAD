import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'student_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder<String>(
          future: AuthService().getRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (roleSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Unable to load user profile.'),
                      ElevatedButton(
                        onPressed: () async {
                          await AuthService().logout();
                        },
                        child: const Text('Sign out'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (roleSnapshot.data == 'teacher') {
              return const HomeScreen();
            }

            return const StudentDashboard();
          },
        );
      },
    );
  }
}