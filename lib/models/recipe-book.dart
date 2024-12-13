import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeBook {
  final String id;
  final String title;
  final String description;
  final double price; // Added price for purchasing the book

  RecipeBook({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  // Factory method to create a RecipeBook from Firestore document
  factory RecipeBook.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeBook(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: data['price']?.toDouble() ?? 0.0, // Ensuring price is a double
    );
  }
}
