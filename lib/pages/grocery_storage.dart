
import 'package:shared_preferences/shared_preferences.dart';

class GroceryStorage {
  final String _key = 'grocery_items';

  Future<List<String>> getIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addIngredients(List<String> newItems) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    final updated = {...current, ...newItems}.toList(); // remove duplicates
    await prefs.setStringList(_key, updated);
  }

  Future<void> clearIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> overwriteIngredients(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, items);
  }
}
