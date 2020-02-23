import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market_list/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market List',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.,
      // ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  List<Item> items = new List<Item>();

  HomePage() {
    items = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState() {
    load();
  }

  var newItemCtrl = TextEditingController();

  void addItem() {
    if (newItemCtrl.text.isEmpty) {
      return;
    }

    setState(() {
      widget.items.add(Item(name: newItemCtrl.text, buyed: false));
      newItemCtrl.text = '';
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);

      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('data', jsonEncode(widget.items));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newItemCtrl,
          style: TextStyle(color: Colors.white, fontSize: 20),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.white),
            labelText: 'Item para comprar...',
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black.withOpacity(0.1),
        child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (BuildContext ctx, int index) {
              final item = widget.items[index];

              return Dismissible(
                child: CheckboxListTile(
                    activeColor: Colors.black,
                    value: item.buyed,
                    title: Text(
                      item.name,
                    ),
                    onChanged: (value) {
                      setState(() {
                        item.buyed = value;
                        save();
                      });
                    }),
                key: Key(item.name + index.toString()),
                background: Container(
                  color: Colors.red.withOpacity(0.2),
                ),
                onDismissed: (direction) {
                  remove(index);
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add_shopping_cart, size: 26),
        onPressed: addItem,
      ),
    );
  }
}
