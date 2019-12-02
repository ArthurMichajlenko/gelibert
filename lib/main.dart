import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//* uncomment when begin using models
import 'models/orders.dart';
// import 'models/couriers.dart';
// import 'models/clients.dart';

// void main() => runApp(GelibertApp());
Database db;
void main() async {
  db = await _openDB();

  runApp(GelibertApp());
}

Future<Database> _openDB() async {
  var databasePath = await getDatabasesPath();
  var path = join(databasePath, "gelibert.db");
  var exists = await databaseExists(path);
  if (!exists) {
    // Creating database from assets
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}
    //Copy from assets
    ByteData data = await rootBundle.load(join("assets", "gelibert.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
  }
  // Open the database
  final db = await openDatabase(path);
  return db;
}

class GelibertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: OrdersPage(title: 'Заказы'),
    );
  }
}

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var _orders = Orders();

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _orders.ordersListWidget(db),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:20),
            ),
            ListTile(
              title: Text('Все заказы'),
            ),
            ListTile(
              title: Text('В работе'),
            ),
            ListTile(
              title: Text('Выполненные'),
            ),
            ListTile(
              title: Text('Отложенные'),
            ),
          ],
        ),
      ),
    );
  }
}
