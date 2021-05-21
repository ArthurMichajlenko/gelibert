// import 'dart:io';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:gilebert/exchange.dart';

import 'models/couriers.dart';
import 'models/orders.dart';
import 'title_orders.dart';

// void main() => runApp(GelibertApp());
Database db;
String dataJson;
String macAddress='100';
bool connected = true;
int orderDelivered;
int countTitle;
Set<String> routLists = {};
String routList;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  db = await _openDB();
  runApp(GelibertApp());
}
// void main() => runApp(GelibertApp());

Future<Database> _openDB() async {
  var databasePath = await getDatabasesPath();
  var path = join(databasePath, "gelibert.db3");
  var exists = await databaseExists(path);
  if (!exists) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
    //Copy from assets
    ByteData data = await rootBundle.load(join("assets", "gelibert.db3"));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
  }
  final _db = await openDatabase(
    path,
    onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
  );
  return _db;
}

Future<void> _initDB(Database db) async {
  dataJson = await rootBundle.loadString(join("assets", "demo_order.json"));
  await fetchDataToSQL(db, dataJson);
  if (routLists.isEmpty) {
    countAll = 0;
    countInWork = 0;
    countComplete = 0;
    countDeffered = 0;
  } else {
    routList = routLists.elementAt(0);
    countAll = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE order_routlist = ?', [routList]));
    countInWork = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 0 AND order_routlist = ?', [routList]));
    countComplete = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 1 AND order_routlist = ?', [routList]));
    countDeffered = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = -1 AND order_routlist = ?', [routList]));
  }
}

Color connectColor() {
  Color colorBackground;
  colorBackground = connected ? Colors.blueGrey : Colors.red;
  return colorBackground;
}

class InitDB extends StatefulWidget {
  @override
  _InitDBState createState() => _InitDBState();
}

class _InitDBState extends State<InitDB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      builder: (context, dbSnap) {
        if (dbSnap.connectionState == ConnectionState.none || dbSnap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Инициализация данных..."),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return OrdersPage(title: 'Заказы');
      },
      future: _initDB(db),
    );
  }
}

class GelibertApp extends StatefulWidget {
  @override
  _GelibertAppState createState() => _GelibertAppState();
}

class _GelibertAppState extends State<GelibertApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/initDB',
      routes: {
        '/initDB': (context) => InitDB(),
        '/ordersPage': (context) => OrdersPage(title: 'Заказы'),
      },
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
  var _courier = Couriers();
  var _routNum = routList;
  var _routNumItems = routLists.toList();

  @override
  void initState() {
    super.initState();
    // orderDelivered = 2;
    orderDelivered = 0;
    // countTitle = countAll;
    countTitle = countInWork;
  }

  @override
  void dispose() {
    // db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(mainTitle),
        backgroundColor: connectColor(),
        // centerTitle: true,
        title: TitleOrders(
          countTitle,
          countAll,
          orderDelivered,
        ),
        actions: <Widget>[
          if (connected)
            IconButton(
              icon: Icon(
                Icons.autorenew,
                color: Colors.white,
              ),
              onPressed: () async {
                await fetchDataToSQL(db, dataJson);
                countAll = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE order_routlist = ?', [_routNum]));
                countInWork = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 0 AND order_routlist = ?', [_routNum]));
                countComplete = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 1 AND order_routlist = ?', [_routNum]));
                countDeffered = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = -1 AND order_routlist = ?', [_routNum]));
                // orderDelivered = 2;
                orderDelivered = 0;
                setState(() {
                  countTitle = countInWork;
                });
              },
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (routLists.length != 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    // 'Маршрутный лист №: ' + routLists.elementAt(0),
                    'Маршрутный лист №: ',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // RaisedButton(
                  //   onPressed: () => print(_routNumItems),
                  //   child: Text(routList),
                  // ),
                  DropdownButton<String>(
                    value: _routNum,
                    items: _routNumItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (String newValue) async {
                      await fetchDataToSQL(db, dataJson);
                      countAll = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE order_routlist = ?', [newValue]));
                      countInWork =
                          Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 0 AND order_routlist = ?', [newValue]));
                      countComplete =
                          Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 1 AND order_routlist = ?', [newValue]));
                      countDeffered =
                          Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = -1 AND order_routlist = ?', [newValue]));
                      // orderDelivered = 2;
                      orderDelivered = 0;
                      setState(() {
                        _routNum = newValue;
                        routList = newValue;
                        countTitle = countInWork;
                      });
                      // print(_routNum);
                    },
                  )
                ],
              ),
            ),
          Flexible(child: _orders.ordersListWidget(db, orderDelivered, _routNum)),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: UserAccountsDrawerHeader(
                accountEmail: _courier.courierCarNumber(db, macAddress),
                accountName: _courier.courierName(db, macAddress),
                currentAccountPicture: CircleAvatar(
                  // backgroundImage: AssetImage('assets/images/Aqua.png'),
                  child: Text(
                    macAddress,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                await db.delete('couriers');
                Navigator.pushNamed(context, '/authPage');
                // return AuthPage();
              },
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
