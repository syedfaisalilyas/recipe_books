import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_books/screens/home-screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Firebase is initialized before app starts

  try {
    await Firebase.initializeApp(); // Initialize Firebase
    print("Firebase Initialization Successful"); // Print success message
  } catch (e) {
    print("Firebase Initialization Failed: $e"); // Print error message if initialization fails
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes Books',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Set initial route to home screen
      routes: {
        '/': (context) =>  HomeScreen(), // Define the HomeScreen route

      },
    );
  }
}

