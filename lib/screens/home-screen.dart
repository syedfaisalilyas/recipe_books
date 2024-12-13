import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe.dart';
import 'create-recipe-screen.dart';
import 'edit-recipe-screen.dart';

class HomeScreen extends StatelessWidget {
  // Fetch the recipes from Firebase Firestore
  Stream<List<Recipe>> getRecipes() {
    return FirebaseFirestore.instance
        .collection('recipes') // Your Firestore collection name
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Recipe(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
        );
      }).toList();
    });
  }

  // Delete the recipe from Firestore
  void _deleteRecipe(String recipeId, BuildContext context) {
    FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .delete()
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting recipe: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateRecipeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading recipes'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found'));
          }

          final recipes = snapshot.data!;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Dismissible(
                key: Key(recipe.id),
                direction: DismissDirection.endToStart, // Swipe from right to left
                onDismissed: (direction) {
                  // Call _deleteRecipe when the recipe is swiped away
                  _deleteRecipe(recipe.id, context);
                },
                child: ListTile(
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRecipeScreen(recipe: recipe),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
