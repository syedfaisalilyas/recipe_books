import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeBook {
  final String id;
  final String title;
  final String description;
  final double price; // Price for purchasing the book
  final String? image; // URL of the book's image (optional)
  final String? type; // Type or category of the book (optional)

  RecipeBook({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.image, // Optional field
    this.type,  // Optional field
  });

  // Factory method to create a RecipeBook from Firestore document
  factory RecipeBook.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeBook(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] is int ? (data['price'] as int).toDouble() : data['price']) ?? 0.0,
      image: data['image'] ?? null, // Handle optional field
      type: data['type'] ?? null,   // Handle optional field
    );
  }

  // Method to convert RecipeBook to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'type': type,
    };
  }
}
