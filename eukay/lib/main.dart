import 'package:eukay/pages/auth_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Remove this line when deploying to production
      title: 'E-Ukay',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFFADB4BF),
          secondary: Color(0xFF164BA1),
          surface: Color(0xFFFFFEFF),
          onSurface: Color(0xFFF0F4FA),
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light, // Use 'dark' for dark theme
        ),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}
