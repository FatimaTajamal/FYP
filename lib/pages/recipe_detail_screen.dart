import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeTitle;
  const RecipeDetailScreen({super.key, required this.recipeTitle});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus(); // Load favorite status when screen opens
  }

  // Load the favorite status from SharedPreferences
  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedRecipes = prefs.getStringList('saved_recipes') ?? [];
    setState(() {
      isFavorite = savedRecipes.contains(widget.recipeTitle);
    });
  }

  // Toggle the favorite status and save it in SharedPreferences
  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedRecipes = prefs.getStringList('saved_recipes') ?? [];

    // Add or remove the recipe from the saved list based on the current state
    if (isFavorite) {
      savedRecipes.remove(widget.recipeTitle);
    } else {
      savedRecipes.add(widget.recipeTitle);
    }

    // Save updated list of favorite recipes to SharedPreferences
    await prefs.setStringList('saved_recipes', savedRecipes);

    // Update the UI state
    setState(() {
      isFavorite = !isFavorite;
    });

    final snackBar = SnackBar(
      content: Text(
        isFavorite ? "Added to Favorites ❤️" : "Removed from Favorites 💔",
      ),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Print to debug
    print("Saved Recipes: $savedRecipes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeTitle),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite, // Trigger the toggle function
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Text(
              widget.recipeTitle,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Placeholder for recipe details
          const Text("Recipe Details"),
        ],
      ),
    );
  }
}