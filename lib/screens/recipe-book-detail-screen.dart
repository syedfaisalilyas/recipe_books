import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_books/models/recipe-book.dart';

class RecipeBookDetailScreen extends StatelessWidget {
  final String recipeBookId;

  const RecipeBookDetailScreen({super.key, required this.recipeBookId});

  // Fetch a single recipe book by its ID from Firestore
  Future<RecipeBook?> getRecipeBookDetail() async {
    try {
      var doc = await FirebaseFirestore.instance.collection('recipe_books').doc(recipeBookId).get();
      if (doc.exists) {
        return RecipeBook.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error fetching recipe book detail: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecipeBook?>(
      future: getRecipeBookDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading recipe book'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Recipe book not found'));
        }

        final recipeBook = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text(recipeBook.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipeBook.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  recipeBook.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                recipeBook.image != null
                    ? Image.network(recipeBook.image!, width: 200, height: 200, fit: BoxFit.cover)
                    : const Icon(Icons.book, size: 100),
                const SizedBox(height: 20),
                Text(
                  'Price: \$${recipeBook.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Type: ${recipeBook.type}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
