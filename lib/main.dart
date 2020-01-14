// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//* uncomment when begin using models
import 'models/orders.dart';
// import 'models/couriers.dart';
// import 'models/clients.dart';
import 'title_orders.dart';

// void main() => runApp(GelibertApp());
Database db;
int orderDelivered;
int countTitle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await _openDB();
  runApp(GelibertApp());
}

Future<Database> _openDB() async {
  var databasePath = await getDatabasesPath();
  var path = join(databasePath, "gelibert.db");
  // var exists = await databaseExists(path);
  // if (!exists) {
  //   // Creating database from assets
  //   try {
  //     await Directory(dirname(path)).create(recursive: true);
  //   } catch (_) {}
  //   //Copy from assets
  //   ByteData data = await rootBundle.load(join("assets", "gelibert.db"));
  //   List<int> bytes =
  //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //   await File(path).writeAsBytes(bytes, flush: true);
  // }
  // Open the database
  final db = await openDatabase(
    path,
    onCreate: (db, version) async {
      String script =
          await rootBundle.loadString(join("assets", "gelibert.sql"));
      List<String> scripts = script.split(";");
      scripts.forEach((v) {
        if (v.isNotEmpty) {
          // print(v.trim());
          db.execute(v.trim());
        }
      });
    },
    version: 1,
  );
  countAll =
      Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders'));
  countInWork = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 0'));
  countComplete = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 1'));
  countDeffered = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = -1'));
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
      debugShowCheckedModeBanner: false,
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
  void initState() {
    orderDelivered = 2;
    countTitle = countAll;
    super.initState();
  }

  @override
  void dispose() {
    db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(mainTitle),
        title: TitleOrders(
          countTitle,
          countAll,
          orderDelivered,
        ),
      ),
      body: _orders.ordersListWidget(db, orderDelivered),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('BLAV437'),
              accountName: Text('Name'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/Aqua.png'),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text('Все заказы'),
                    onTap: () {
                      setState(() {
                        countTitle = countAll;
                        return orderDelivered = 2;
                      });
                      Navigator.pop(context);
                    },
                    trailing: Chip(
                      label: Text(
                        countAll.toString(),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.airport_shuttle),
                    title: Text('В работе'),
                    onTap: () {
                      setState(() {
                        countTitle = countInWork;
                        return orderDelivered = 0;
                      });
                      Navigator.pop(context);
                    },
                    trailing: Chip(
                      label: Text(
                        countInWork.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.check),
                    title: Text('Выполненные'),
                    onTap: () {
                      setState(() {
                        countTitle = countComplete;
                        return orderDelivered = 1;
                      });
                      Navigator.pop(context);
                    },
                    trailing: Chip(
                      label: Text(
                        countComplete.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.av_timer),
                    title: Text('Отложенные'),
                    onTap: () {
                      setState(() {
                        countTitle = countDeffered;
                        return orderDelivered = -1;
                      });
                      Navigator.pop(context);
                    },
                    trailing: Chip(
                      label: Text(
                        countDeffered.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
