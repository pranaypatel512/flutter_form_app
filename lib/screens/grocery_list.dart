import 'package:flutter/material.dart';
import 'package:flutter_form_app/data/dummy_items.dart';
import 'package:flutter_form_app/data/grocery_item.dart';
import 'package:flutter_form_app/screens/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryList = [];
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('There is no task data'),
    );
    if (_groceryList.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            trailing: Text(_groceryList[index].quantity.toString()),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryList[index].category.color,
            ),
            title: Text(_groceryList[index].name),
          );
        },
        itemCount: _groceryList.length,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Groceries'),
          actions: [
            IconButton(
                onPressed: () async {
                  final newItem = await Navigator.of(context).push<GroceryItem>(
                      MaterialPageRoute(builder: (builder) => NewItemScreen()));
                  if (newItem == null) {
                    return;
                  }
                  setState(() {
                    _groceryList.add(newItem);
                  });
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
