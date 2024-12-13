import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe.dart'; // Your Recipe model

class CreateRecipeScreen extends StatefulWidget {
  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false; // To show loading state while submitting

  void _createRecipe() async {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      // Optionally, show an error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide both title and description')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true; // Set the submitting state
    });

    try {
      final newRecipe = Recipe(
        id: DateTime.now().toString(), // Unique ID based on time
        title: title,
        description: description,
      );

      // Add recipe to Firebase Firestore
      await FirebaseFirestore.instance.collection('recipes').add({
        'title': newRecipe.title,
        'description': newRecipe.description,
        'createdAt': FieldValue.serverTimestamp(), // Optionally add timestamp
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe created successfully!')),
      );

      // Go back to the previous screen after creation
      Navigator.pop(context);
    } catch (e) {
      // Show error message in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create recipe: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false; // Reset submitting state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Recipe Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Recipe Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _createRecipe, // Disable button while submitting
              child: _isSubmitting
                  ? CircularProgressIndicator() // Show a loading indicator while submitting
                  : Text('Create Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
