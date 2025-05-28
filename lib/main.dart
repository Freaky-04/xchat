// lib/main.dart
import 'package:flutter/material.dart';
import 'package:xchat/screens/login_screen.dart'; // Adjust import path if needed

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light, // Or Brightness.dark for dark theme
        ),
        useMaterial3: true,
        // Add custom text themes, button themes etc. for more "awesomeness"
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
            )
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade100.withOpacity(0.5),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // Start with LoginScreen
    );
  }
}