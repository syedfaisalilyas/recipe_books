import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe-book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRecipeBookScreen extends StatefulWidget {
  final RecipeBook recipeBook;

  EditRecipeBookScreen({required this.recipeBook});

  @override
  _EditRecipeBookScreenState createState() => _EditRecipeBookScreenState();
}

class _EditRecipeBookScreenState extends State<EditRecipeBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipeBook.title);
    _descriptionController = TextEditingController(text: widget.recipeBook.description);
    _priceController = TextEditingController(text: widget.recipeBook.price.toString());
  }

  void _updateRecipeBook() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final priceText = _priceController.text;
    final price = double.tryParse(priceText) ?? 0.0; // Ensure price is a valid double

    if (title.isEmpty || description.isEmpty || price <= 0) {
      // You can show a message if the inputs are invalid
      return;
    }

    final updatedRecipeBook = RecipeBook(
      id: widget.recipeBook.id,
      title: title,
      description: description,
      price: price,
    );

    try {
      // Update the recipe book in Firestore
      await FirebaseFirestore.instance.collection('recipe_books').doc(widget.recipeBook.id).update({
        'title': updatedRecipeBook.title,
        'description': updatedRecipeBook.description,
        'price': updatedRecipeBook.price,
      });

      // Go back after updating
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors that might occur during the update
      print('Error updating recipe book: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe Book'),
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
            ElevatedButton(
              onPressed: _updateRecipeBook,
              child: const Text('Update Recipe Book'),
            ),
          ],
        ),
      ),
    );
  }
}
