import 'package:flutter/material.dart';
import 'package:flutter_form_app/data/dummy_items.dart';
import 'package:flutter_form_app/screens/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (builder) => NewItemScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
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
