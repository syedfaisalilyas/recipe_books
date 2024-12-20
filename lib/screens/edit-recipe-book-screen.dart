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
  final _imageController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize the controllers with the existing recipe book data
    _titleController.text = recipeBook.title;
    _descriptionController.text = recipeBook.description;
    _priceController.text = recipeBook.price.toString();
    _imageController.text = recipeBook.image ?? ''; // Handle null image
    _typeController.text = recipeBook.type ?? ''; // Handle null type

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                keyboardType: TextInputType.url,
              ),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final updatedTitle = _titleController.text.trim();
                  final updatedDescription = _descriptionController.text.trim();
                  final updatedPrice =
                      double.tryParse(_priceController.text.trim()) ?? 0.0;
                  final updatedImage = _imageController.text.trim();
                  final updatedType = _typeController.text.trim();

                  if (updatedTitle.isNotEmpty &&
                      updatedDescription.isNotEmpty &&
                      updatedImage.isNotEmpty &&
                      updatedType.isNotEmpty) {
                    final updatedRecipeBook = RecipeBook(
                      id: recipeBook.id, // Use the same ID as the original book
                      title: updatedTitle,
                      description: updatedDescription,
                      price: updatedPrice,
                      image: updatedImage,
                      type: updatedType,
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
      ),
    );
  }
}
