import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/cart-item.dart';
import '../models/recipe-book.dart'; // Assuming your RecipeBook model is imported
import 'user-home-screen.dart'; // Assuming this is the home screen file

class CartScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  // Function to merge duplicate items in the cart
  List<CartItem> _mergeCartItems() {
    final Map<String, CartItem> mergedItems = {};

    for (var item in cartItems) {
      if (mergedItems.containsKey(item.recipeBook.id)) {
        // If item already exists, increment its quantity
        mergedItems[item.recipeBook.id] = CartItem(
          recipeBook: item.recipeBook,
          quantity: mergedItems[item.recipeBook.id]!.quantity + item.quantity,
        );
      } else {
        // Otherwise, add it to the map
        mergedItems[item.recipeBook.id] = item;
      }
    }

    // Convert the map back to a list
    return mergedItems.values.toList();
  }

  // Function to handle purchase and store in Firebase
  Future<void> _handlePurchase(BuildContext context) async {
    try {
      final mergedCartItems = _mergeCartItems();

      // Create a new purchase in Firestore
      final purchaseRef = FirebaseFirestore.instance.collection('purchases').doc();

      // Prepare the purchase data
      final purchaseData = mergedCartItems.map((cartItem) {
        return {
          'recipeBookId': cartItem.recipeBook.id,
          'title': cartItem.recipeBook.title,
          'quantity': cartItem.quantity,
          'price': cartItem.recipeBook.price,
        };
      }).toList();

      // Save the data to Firestore
      await purchaseRef.set({
        'items': purchaseData,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'completed', // You can set this based on your logic (e.g., 'pending' or 'completed')
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase successful!')),
      );

      // Navigate back to the home screen after purchase
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserHomeScreen()), // Navigate to home screen
            (route) => false, // Remove all the previous routes (back stack)
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing purchase: $e')),
      );
    }
  }

  // Calculate the total amount in the cart
  double getTotalAmount() {
    final mergedCartItems = _mergeCartItems();

    return mergedCartItems.fold(0, (sum, item) {
      return sum + (item.recipeBook.price * item.quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mergedCartItems = _mergeCartItems();
    final totalAmount = getTotalAmount();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: mergedCartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mergedCartItems.length,
              itemBuilder: (context, index) {
                final cartItem = mergedCartItems[index];
                return ListTile(
                  title: Text(cartItem.recipeBook.title),
                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                  trailing: Text(
                    '\$${(cartItem.recipeBook.price * cartItem.quantity).toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      bottomNavigationBar: mergedCartItems.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Call the purchase handling function
            _handlePurchase(context);
          },
          child: const Text('Proceed to Checkout'),
        ),
      ),
    );
  }
}
