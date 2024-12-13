import 'package:flutter/material.dart';
import 'package:recipe_books/models/cart-item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Add item to cart
  void addToCart(CartItem item) {
    // Check if the item already exists in the cart
    final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.recipeBook.id == item.recipeBook.id);
    if (existingItemIndex >= 0) {
      // If item exists, increase quantity
      _cartItems[existingItemIndex].quantity += item.quantity;
    } else {
      // Otherwise, add the new item to the cart
      _cartItems.add(item);
    }
    notifyListeners(); // Notify listeners to update UI
  }

  // Remove item from cart by its ID
  void removeFromCart(String itemId) {
    _cartItems.removeWhere((item) => item.recipeBook.id == itemId);
    notifyListeners(); // Notify listeners after removal
  }

  // Calculate the total price of items in the cart
  double get total {
    return _cartItems.fold(0.0, (sum, item) => sum + item.recipeBook.price * item.quantity);
  }
}
