// import 'dart:io';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';

//* uncomment when begin using models
import 'models/orders.dart';
// import 'models/couriers.dart';
// import 'models/clients.dart';
import 'title_orders.dart';

// void main() => runApp(GelibertApp());
Database db;
String token;
final serverURL = 'http://10.10.11.135:1323/login';
int orderDelivered;
int countTitle;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   db = await _openDB();
//   runApp(GelibertApp());
// }
void main() => runApp(GelibertApp());

Future<Database> _openDB() async {
  var databasePath = await getDatabasesPath();
  var path = join(databasePath, "gelibert.db");
  final db = await openDatabase(
    path,
    onCreate: (db, version) async {
      String script =
          // await rootBundle.loadString(join("assets", "gelibert.sql"));
          await rootBundle.loadString(join("assets", "gelibert_data.sql"));
      List<String> scripts = script.split(";");
      scripts.forEach((v) {
        if (v.isNotEmpty) {
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

Future<String> _fetchJWTToken(String url) async {
  try {
    var res = await http.post(url, body: {'imei': await ImeiPlugin.getImei()});
    if (res.statusCode != 200) {
      return "Unauthorized";
    }
    Map<String, dynamic> tk = jsonDecode(res.body);
    return tk['token'];
    // } on SocketException catch (e) {
  } catch (_) {
    return "Unconnect";
  }
}

class ConnectToServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      builder: (context, startSnap) {
        if (startSnap.connectionState == ConnectionState.none ||
            startSnap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Подключение..."),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        token = startSnap.data;
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => OrdersPage(
        //       title: 'Заказы',
        //     ),
        //   ),
        // );
        if (token == 'Unauthorized') {
          return AlertDialog(
            title: Text('Unauthorized'),
            content: Text('Устройство не зарегистрированно...'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Text('Выйти из программы')),
            ],
          );
        }
        if (token == 'Unconnect') {
          return AlertDialog(
            title: Text('Unconnect'),
            content: Text('Нет связи с сервером...'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => SystemNavigator.pop(),
                  child: Text('Выйти из программы')),
            ],
          );
        }
        print(token);
        // return OrdersPage(title: 'Заказы');
        return InitDB();
      },
      future: _fetchJWTToken(serverURL),
    );
  }
}

class InitDB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
      builder: (context, dbSnap) {
        if (dbSnap.connectionState == ConnectionState.none ||
            dbSnap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Инициализация данных..."),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        db = dbSnap.data;
        print(db);
        return OrdersPage(title: 'Заказы');
      },
      future: _openDB(),
    );
  }
}

class GelibertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      // home: OrdersPage(title: 'Заказы'),
      home: ConnectToServer(),
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
