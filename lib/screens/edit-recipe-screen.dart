import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_books/models/recipe.dart';

class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;

  EditRecipeScreen({required this.recipe});

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController = TextEditingController(text: widget.recipe.description);
  }

  void _updateRecipe() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isEmpty || description.isEmpty) {
      return;
    }

    final updatedRecipe = Recipe(
      id: widget.recipe.id,
      title: title,
      description: description,
    );

    try {
      // Update the recipe in Firestore
      await FirebaseFirestore.instance.collection('recipes').doc(widget.recipe.id).update({
        'title': updatedRecipe.title,
        'description': updatedRecipe.description,
      });

      // Go back after updating
      Navigator.pop(context);
    } catch (e) {
      // Handle any errors that might occur during the update
      print('Error updating recipe: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Recipe'),
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
            ElevatedButton(
              onPressed: _updateRecipe,
              child: const Text('Update Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
