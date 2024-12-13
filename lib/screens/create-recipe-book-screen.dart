import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe-book.dart'; // Your RecipeBook model

class CreateRecipeBookScreen extends StatefulWidget {
  @override
  _CreateRecipeBookScreenState createState() => _CreateRecipeBookScreenState();
}

class _CreateRecipeBookScreenState extends State<CreateRecipeBookScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isSubmitting = false; // To show loading state while submitting

  void _createRecipeBook() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final priceText = _priceController.text;
    final price = double.tryParse(priceText) ?? 0.0; // Ensure price is a valid double

    if (title.isEmpty || description.isEmpty || price <= 0) {
      // Optionally, show an error message if fields are empty or invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide valid title, description, and price')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true; // Set the submitting state
    });

    try {
      final newRecipeBook = RecipeBook(
        id: DateTime.now().toString(), // Unique ID based on time
        title: title,
        description: description,
        price: price,
      );

      // Add recipe book to Firebase Firestore
      await FirebaseFirestore.instance.collection('recipe_books').add({
        'title': newRecipeBook.title,
        'description': newRecipeBook.description,
        'price': newRecipeBook.price,
        'createdAt': FieldValue.serverTimestamp(), // Optionally add timestamp
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe Book created successfully!')),
      );

      // Go back to the previous screen after creation
      Navigator.pop(context);
    } catch (e) {
      // Show error message in case of failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create recipe book: $e')),
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
        title: const Text('Create Recipe Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Recipe Book Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Recipe Book Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _createRecipeBook, // Disable button while submitting
              child: _isSubmitting
                  ? CircularProgressIndicator() // Show a loading indicator while submitting
                  : Text('Create Recipe Book'),
            ),
          ],
        ),
      ),
    );
  }
}
