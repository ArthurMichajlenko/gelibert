import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'order_detail.dart';
//* uncomment when begin using models
// import 'models/orders.dart';
// import 'models/couriers.dart';
// import 'models/clients.dart';

// void main() => runApp(GelibertApp());
Database db;
void main() async {
  await _workdb();

  runApp(GelibertApp());
}

Future _workdb() async {
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
  //* remove when begin using db
  print(db);
}

class GelibertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: OrdersPage(title: 'Orders'),
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
  int _counter = 0;

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrderDetail()));
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      child: Icon(Icons.shopping_cart),
                    ),
                  ),
                ),
                title: Text('Curier: ' + '$_counter'),
                onTap: () => launch("tel:+3736913040"),
                dense: false,
                enabled: true,
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

