import 'package:flutter/material.dart';
import 'package:flutter_form_app/data/categories.dart';
import 'package:flutter_form_app/data/grocery_item.dart';
import 'package:flutter_form_app/models/category.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _forsState = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() {
    if (_forsState.currentState!.validate()) {
      _forsState.currentState!.save();
      Navigator.of(context).pop(GroceryItem(id: DateTime.now().toString(), 
      name: _enteredName, quantity: _enteredQuantity,
       category: _selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Groceries')),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
              key: _forsState,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1 ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters.';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _enteredName = newValue!;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(label: Text('Quantity')),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              return 'Must be between a valid positive number';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredQuantity = int.parse(newValue!);
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                  value: category.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: category.value.color,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(category.value.name),
                                    ],
                                  ))
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            _forsState.currentState?.reset();
                          },
                          child: Text('Reset')),
                      ElevatedButton(
                          onPressed: _saveItem, child: Text('Add Item'))
                    ],
                  )
                ],
              )),
        ));
  }
}
