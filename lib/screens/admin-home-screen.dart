import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_books/models/recipe-book.dart';
import '../firebase_messaging_service.dart';
import 'auth.dart';
import 'create-recipe-book-screen.dart';
import 'edit-recipe-book-screen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseMessagingService _firebaseMessagingService =
  FirebaseMessagingService(); // Initialize notification service

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

  // Delete the recipe book from Firestore
  void _deleteRecipeBook(String recipeBookId, BuildContext context) {
    FirebaseFirestore.instance
        .collection('recipe_books')
        .doc(recipeBookId)
        .delete()
        .then((_) {
      // Show notification on recipe book deletion
      _firebaseMessagingService.showNotification(
        'Recipe Book Deleted',
        'The recipe book has been successfully deleted.',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe book deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting recipe book: $error')),
      );
    });
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
                  builder: (context) => CreateRecipeBookScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<RecipeBook>>(
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
                      direction: DismissDirection.endToStart, // Swipe from right to left
                      onDismissed: (direction) {
                        // Call _deleteRecipeBook when the recipe book is swiped away
                        _deleteRecipeBook(recipeBook.id, context);
                      },
                      background: Container(
                        color: Colors.red, // Set the swipe background color to red
                        alignment: Alignment.centerRight, // Align the icon to the right
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(
                          Icons.delete, // Display a delete icon
                          color: Colors.white, // Icon color
                        ),
                      ),
                      child: ListTile(
                        title: Text(recipeBook.title),
                        subtitle: Text(recipeBook.description),
                        trailing:
                        Text('\$${recipeBook.price.toStringAsFixed(2)}'), // Displaying price
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditRecipeBookScreen(recipeBook: recipeBook),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Customize button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
