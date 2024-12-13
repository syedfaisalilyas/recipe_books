import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isauthenticating = false;
  var _enteredemail = '';
  var _enteredusername = '';
  var _enteredpassword = '';
  var _islogin = true;
  var _successMessage = '';  // Flag for success message

  void _issubmit() async {
    var isvalid = _form.currentState!.validate();
    if (!isvalid) {
      // Display error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please check your inputs.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isauthenticating = true;
        _successMessage = ''; // Reset the success message
      });
      if (_islogin) {
        // Login logic
        final usercredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredemail, password: _enteredpassword);

        // On successful login
        setState(() {
          _successMessage = 'Login successful! Welcome, ${usercredentials.user!.email}';
          _isauthenticating = false;
        });
      } else {
        // Sign-up logic
        final usercredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredemail, password: _enteredpassword);

        // Store user details in Firestore without image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercredentials.user!.uid)
            .set({
          'username': _enteredusername,
          'email': _enteredemail,
        });

        // On successful registration
        setState(() {
          _successMessage = 'Registration successful! Welcome, $_enteredusername';
          _isauthenticating = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ?? 'Authentication failed',
          ),
        ),
      );
      setState(() {
        _isauthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                width: 200,
                child: Image.asset("assets/images/recipeLogo.png"),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_islogin)
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Username'),
                            enableSuggestions: true,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 4) {
                                return 'Please enter at least 4 letters';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredusername = value!;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email Address'),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredemail = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredpassword = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_isauthenticating)
                          const CircularProgressIndicator(),
                        if (!_isauthenticating)
                          ElevatedButton(
                            onPressed: _issubmit,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                            child: Text(_islogin ? 'Login' : 'Signup'),
                          ),
                        if (!_isauthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _islogin = !_islogin;
                              });
                            },
                            child: Text(_islogin
                                ? 'Create an account'
                                : 'I already have an account'),
                          ),
                        if (_successMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              _successMessage,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
