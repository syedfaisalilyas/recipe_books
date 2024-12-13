import 'package:flutter/material.dart';

import '../screens/auth.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Customize button color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.white, // Text color
          fontSize: 16,
        ),
      ),
    );
  }
}
