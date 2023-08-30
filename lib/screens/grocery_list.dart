import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_app/data/categories.dart';
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
  late Future<List<GroceryItem>> _loadedItems;
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder(
            future: _loadedItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('There is no task data'),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(snapshot.data![index].id),
                    onDismissed: (direction) {
                      _deleteItem(snapshot.data![index]);
                    },
                    child: ListTile(
                      trailing: Text(snapshot.data![index].quantity.toString()),
                      leading: Container(
                        width: 24,
                        height: 24,
                        color: snapshot.data![index].category.color,
                      ),
                      title: Text(snapshot.data![index].name),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }));
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

  void _deleteItem(GroceryItem item) async {
    final index = _groceryList.indexOf(item);
    setState(() {
      _groceryList.remove(item);
    });
    final url = Uri.https('fir-prep-c590d-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryList.insert(index, item);
      });
    }
  }

  Future<List<GroceryItem>> _loadItem() async {
    final url = Uri.https(
        'fir-prep-c590d-default-rtdb.firebaseio', 'shopping-list.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch data. Please try again later.');
    }

    if (response.body == 'null') {
      return [];
    }
    final List<GroceryItem> loadedItems = [];
    final Map<String, dynamic> listData = json.decode(response.body);
    for (final item in listData.entries) {
      loadedItems.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: categories.entries
            .firstWhere(
                (element) => element.value.name == item.value['category']!)
            .value,
      ));
    }
    return loadedItems;
  }

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItem();
  }
}
