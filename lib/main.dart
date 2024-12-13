import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_books/screens/auth.dart';
import 'screens/user-home-screen.dart';  // Import UserHomeScreen
import 'screens/admin-home-screen.dart';  // Import AdminHomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Books',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthScreen(), // Authentication Screen
        '/home': (context) => HomeScreen(), // Admin Home Screen
        '/user-home': (context) => UserHomeScreen(), // User Home Screen
      },
    );
  }
}
