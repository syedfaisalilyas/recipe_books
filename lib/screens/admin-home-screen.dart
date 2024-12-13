import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_books/models/recipe-book.dart';
import '../firebase_messaging_service.dart';
import 'auth.dart';
import 'create-recipe-book-screen.dart';
import 'edit-recipe-book-screen.dart';

class HomeScreen extends StatelessWidget {
  // Fetch the recipe books from Firebase Firestore
  Stream<List<RecipeBook>> getRecipeBooks() {
    return FirebaseFirestore.instance
        .collection('recipe_books') // Your Firestore collection name
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RecipeBook.fromFirestore(doc); // Use fromFirestore to create RecipeBook from Firestore document
      }).toList();
    });
  }

  // Show a notification after adding a new recipe book
  void _showAddNotification(String title, String description) {
    FirebaseMessagingService().showNotification(
      'New Recipe Book Added',
      'Title: $title\nDescription: $description',
    );
  }

  // Show a notification after updating a recipe book
  void _showUpdateNotification(String title, String description) {
    FirebaseMessagingService().showNotification(
      'Recipe Book Updated',
      'Title: $title\nDescription: $description',
    );
  }

  // Show a notification after deleting a recipe book
  void _showDeleteNotification(String title) {
    FirebaseMessagingService().showNotification(
      'Recipe Book Deleted',
      'Title: $title has been deleted.',
    );
  }

  // Add the recipe book to Firestore
  Future<void> _addRecipeBook(RecipeBook recipeBook, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('recipe_books').add({
        'title': recipeBook.title,
        'description': recipeBook.description,
        'price': recipeBook.price,
      });

      // Show a notification after adding the book
      _showAddNotification(recipeBook.title, recipeBook.description);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe book added')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding recipe book: $error')),
      );
    }
  }

  // Update the recipe book in Firestore
  Future<void> _updateRecipeBook(String recipeBookId, RecipeBook updatedRecipeBook, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipe_books')
          .doc(recipeBookId)
          .update({
        'title': updatedRecipeBook.title,
        'description': updatedRecipeBook.description,
        'price': updatedRecipeBook.price,
      });

      // Show a notification after updating the book
      _showUpdateNotification(updatedRecipeBook.title, updatedRecipeBook.description);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe book updated')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating recipe book: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateRecipeBookScreen(
                    onAdd: (recipeBook) {
                      _addRecipeBook(recipeBook, context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<RecipeBook>>(
        stream: getRecipeBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading recipe books'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipe books found'));
          }

          final recipeBooks = snapshot.data!;

          return ListView.builder(
            itemCount: recipeBooks.length,
            itemBuilder: (context, index) {
              final recipeBook = recipeBooks[index];
              return Dismissible(
                key: Key(recipeBook.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteRecipeBook(recipeBook.id, recipeBook.title, context);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  title: Text(recipeBook.title),
                  subtitle: Text(recipeBook.description),
                  trailing: Text('\$${recipeBook.price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRecipeBookScreen(
                          recipeBook: recipeBook,
                          onUpdate: (updatedRecipeBook) {
                            _updateRecipeBook(
                              recipeBook.id,
                              updatedRecipeBook,
                              context,
                            );
                          },
                        ),
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

  // Delete a recipe book from Firestore
  void _deleteRecipeBook(String recipeBookId, String title, BuildContext context) {
    FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipeBookId)
        .delete()
        .then((_) {
      // Show a notification after deletion
      _showDeleteNotification(title);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe book deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting recipe book: $error')),
      );
    });
  }
}
