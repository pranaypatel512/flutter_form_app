import 'package:flutter/material.dart';
import 'package:flutter_form_app/data/dummy_items.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groceries')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            trailing: Text(groceryItems[index].quantity.toString()),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryItems[index].category.color,
            ),
            title: Text(groceryItems[index].name),
          );
        },
        itemCount: groceryItems.length,
      ),
    );
  }
}
