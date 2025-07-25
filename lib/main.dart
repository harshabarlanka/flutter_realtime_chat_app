import 'package:flutter/material.dart';
import 'screens/authentication/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chat',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
