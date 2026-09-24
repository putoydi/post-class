import 'package:flutter/material.dart';
// 1. Import your login screen file here
import 'screens/auth_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post-Class App',
      debugShowCheckedModeBanner: false, // Removes the red debug banner
      theme: ThemeData(
        useMaterial3: true,
        // Optional: Set default typography across the entire app
        brightness: Brightness.light,
      ),
      // 2. Set the LoginScreen as the landing/home widget
      home: const LoginScreen(), 
    );
  }
}