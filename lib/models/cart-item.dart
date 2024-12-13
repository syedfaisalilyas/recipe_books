import 'package:recipe_books/models/recipe-book.dart';

class CartItem {
  final RecipeBook recipeBook;
  int quantity;

  CartItem({required this.recipeBook, required this.quantity});
}

