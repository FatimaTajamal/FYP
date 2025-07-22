import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'grocery_storage.dart';

class GroceryController extends GetxController {
  var groceryList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFromStorage();
  }

  void addItem(String item) {
    if (item.isNotEmpty && !groceryList.any((e) => e['name'] == item)) {
      groceryList.add({"name": item, "checked": false});
      GroceryStorage().addIngredients([item]);
    }
  }

  void addItems(List<String> items) {
    bool added = false;
    for (var item in items) {
      if (item.isNotEmpty && !groceryList.any((e) => e['name'] == item)) {
        groceryList.add({"name": item, "checked": false});
        added = true;
      }
    }
    if (added) {
      groceryList.refresh();
      GroceryStorage().addIngredients(items);
    }
  }

  void toggleCheck(int index) {
    groceryList[index]["checked"] = !groceryList[index]["checked"];
    groceryList.refresh();
  }

  void removeItem(int index) async {
    final removed = groceryList.removeAt(index);
    final existing = await GroceryStorage().getIngredients();
    existing.remove(removed["name"]);
    await GroceryStorage().overwriteIngredients(existing);
  }

  void clearAll() async {
    groceryList.clear();
    await GroceryStorage().clearIngredients();
  }

  void loadFromStorage() async {
    final savedItems = await GroceryStorage().getIngredients();
    for (var item in savedItems) {
      if (!groceryList.any((e) => e["name"] == item)) {
        groceryList.add({"name": item, "checked": false});
      }
    }
  }
}
class GroceryListScreen extends StatelessWidget {
  final GroceryController controller = Get.put(GroceryController());
  GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController input = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "My Grocery List",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Clear All",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text("Clear Grocery List"),
                      content: const Text(
                        "Are you sure you want to remove all items?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Clear"),
                        ),
                      ],
                    ),
              );
              if (confirm == true) controller.clearAll();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(input),
            const SizedBox(height: 20),
            Text(
              "Your Items",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildGroceryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController input) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: input,
              style: GoogleFonts.poppins(fontSize: 16),
              decoration: const InputDecoration(
                hintText: "Add grocery item...",
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                controller.addItem(val.trim());
                input.clear();
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: Colors.deepOrange,
              size: 30,
            ),
            onPressed: () {
              controller.addItem(input.text.trim());
              input.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroceryList() {
    return Expanded(
      child: Obx(() {
        if (controller.groceryList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  "Your grocery list is empty",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: controller.groceryList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = controller.groceryList[index];
            return Slidable(
              key: ValueKey(item["name"]),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => controller.removeItem(index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: item["checked"],
                    activeColor: Colors.deepOrange,
                    onChanged: (_) => controller.toggleCheck(index),
                  ),
                  title: Text(
                    item["name"],
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      decoration:
                          item["checked"] ? TextDecoration.lineThrough : null,
                      color: item["checked"] ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
