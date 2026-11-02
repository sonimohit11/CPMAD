import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("hello")),

      body: SafeArea(
        child: Column(
          children: [
            Text('hellow from Flutter'),
              Image.file(
                File("D:\\PHOto\\IMG_20230626_155701.jpg"),
            ),
          ],
        ),
      ),
    );
  }
}
