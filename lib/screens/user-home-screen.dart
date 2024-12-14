import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cart-item.dart';
import '../models/recipe-book.dart';
import 'auth.dart';
import 'cart-screen.dart';
import 'recipe-book-detail-screen.dart'; // Assuming a detailed screen exists
import '../firebase_messaging_service.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  // List to hold cart items in-memory
  List<CartItem> _cart = [];

  // Fetch recipe books from Firebase Firestore
  Stream<List<RecipeBook>> getRecipeBooks() {
    return FirebaseFirestore.instance
        .collection('recipe_books')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RecipeBook.fromFirestore(doc); // Use fromFirestore to create RecipeBook from Firestore document
      }).toList();
    });
  }

  // Add item to the cart
  void _addToCart(RecipeBook recipeBook) {
    setState(() {
      _cart.add(CartItem(recipeBook: recipeBook, quantity: 1));
    });

    // Show snackbar for item added to the cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${recipeBook.title} added to cart')),
    );
  }

  // Show a notification after adding an item to the cart
  void _showAddToCartNotification(RecipeBook recipeBook) {
    FirebaseMessagingService().showNotification(
      'Added to Cart',
      '${recipeBook.title} has been added to your cart.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Books'),
        actions: [
          // Cart icon to navigate to the CartScreen
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        _cart.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Navigate to the Cart Screen and pass the cart data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cartItems: _cart),
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
                    return ListTile(
                      leading: recipeBook.image != null
                          ? Image.network(
                        recipeBook.image!, // Display image from the URL if available
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : const Icon(Icons.book), // Placeholder if no image
                      title: Text(recipeBook.title),
                      subtitle: Text(recipeBook.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          // Add recipe book to cart and show notification
                          _addToCart(recipeBook);
                          _showAddToCartNotification(recipeBook);
                        },
                      ),
                      onTap: () {
                        // Navigate to detailed screen and pass recipeBookId as an argument
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeBookDetailScreen(
                              recipeBookId: recipeBook.id, // Pass the recipeBookId here
                            ),
                          ),
                        );
                      },
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
