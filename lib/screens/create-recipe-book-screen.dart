import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe-book.dart';

class CreateRecipeBookScreen extends StatelessWidget {
  final Function(RecipeBook) onAdd;

  CreateRecipeBookScreen({required this.onAdd, Key? key}) : super(key: key);

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

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
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();
                final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

                if (title.isNotEmpty && description.isNotEmpty) {
                  final recipeBook = RecipeBook(
                    id: '', // Firestore generates the ID, so it can be empty here
                    title: title,
                    description: description,
                    price: price,
                  );
                  onAdd(recipeBook); // Pass the new recipe book to the callback
                  Navigator.pop(context); // Navigate back to the previous screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                }
              },
              child: const Text('Add Recipe Book'),
            ),
          ],
        ),
      ),
    );
  }
}
