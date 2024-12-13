import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe-book.dart';

class EditRecipeBookScreen extends StatelessWidget {
  final RecipeBook recipeBook;
  final Function(RecipeBook) onUpdate;

  EditRecipeBookScreen({
    required this.recipeBook,
    required this.onUpdate,
    Key? key,
  }) : super(key: key);

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize the controllers with the existing recipe book data
    _titleController.text = recipeBook.title;
    _descriptionController.text = recipeBook.description;
    _priceController.text = recipeBook.price.toString();

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
                final updatedTitle = _titleController.text.trim();
                final updatedDescription = _descriptionController.text.trim();
                final updatedPrice =
                    double.tryParse(_priceController.text.trim()) ?? 0.0;

                if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                  final updatedRecipeBook = RecipeBook(
                    id: recipeBook.id, // Use the same ID as the original book
                    title: updatedTitle,
                    description: updatedDescription,
                    price: updatedPrice,
                  );
                  onUpdate(updatedRecipeBook); // Pass the updated recipe book to the callback
                  Navigator.pop(context); // Navigate back to the previous screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                }
              },
              child: const Text('Update Recipe Book'),
            ),
          ],
        ),
      ),
    );
  }
}
