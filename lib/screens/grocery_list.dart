import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_app/data/categories.dart';
import 'package:flutter_form_app/data/dummy_items.dart';
import 'package:flutter_form_app/data/grocery_item.dart';
import 'package:flutter_form_app/screens/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryList = [];
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('There is no task data'),
    );
    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_groceryList.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(_groceryList[index].id),
            onDismissed: (direction) {
              setState(() {
                _groceryList.removeAt(index);
              });
            },
            child: ListTile(
              trailing: Text(_groceryList[index].quantity.toString()),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryList[index].category.color,
              ),
              title: Text(_groceryList[index].name),
            ),
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
                onPressed: () {
                  _addItem();
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: content);
  }

  void _addItem() async {
    final item = await Navigator.of(context).push<GroceryItem>(
        MaterialPageRoute(builder: (builder) => NewItemScreen()));

    if (item == null) {
      return;
    }
    setState(() {
      _groceryList.add(item);
      isLoading = false;
    });
  }

  void _loadItem() async {
    final url = Uri.https(
        'fir-prep-c590d-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    final List<GroceryItem> _loadedItems = [];
    final Map<String, dynamic> listData = json.decode(response.body);
    for (final item in listData.entries) {
      _loadedItems.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: categories.entries
            .firstWhere(
                (element) => element.value.name == item.value['category']!)
            .value,
      ));
    }
    setState(() {
      _groceryList = _loadedItems;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItem();
  }
}
