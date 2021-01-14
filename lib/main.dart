// import 'dart:io';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'models/orders.dart';
import 'models/couriers.dart';
import 'models/clients.dart';
import 'title_orders.dart';
import 'package:get_mac/get_mac.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

// void main() => runApp(GelibertApp());
Database db;
String token = 'Notoken';
String macAddress;
// Couriers courier;
// DevServer work
final serverProtocol = 'http';
final serverAddress = '10.10.11.156';
final serverPort = 1323;
final serverURL = serverProtocol + '://' + serverAddress + ':' + serverPort.toString();
bool connected = false;
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
  final _db = await openDatabase(path);
  await _fetchDataToSQL(_db, serverURL);
  countAll = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM orders'));
  countInWork = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 0'));
  countComplete = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 1'));
  countDeffered = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = -1'));
  return _db;
}

Future<String> _fetchJWTToken(String url) async {
  macAddress = await GetMac.macAddress;
  if (token == 'Notoken' || token == 'Unconnect') {
    try {
      var res = await http.post(url + "/login", body: {'macAddress': macAddress});
      if (res.statusCode != 200) {
        connected = false;
        return "Unauthorized";
      }
      Map<String, dynamic> tk = jsonDecode(res.body);
      connected = true;
      return tk['token'];
      // } on SocketException catch (e) {
    } catch (_) {
      connected = false;
      return "Unconnect";
    }
  }
  return token;
}

Future _fetchDataToSQL(Database db, String url) async {
  http.Response response;
  List<Orders> orders;
  Couriers couriers;
  List<Clients> clients;
  try {
    response = await http.get(url + "/data/orders", headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    switch (response.statusCode) {
      case 200:
        connected = true;
        isOrdersEmpty = false;
        orders = ordersFromJson(response.body);
        var sqlRes = await db.query('orders');
        if (sqlRes.isNotEmpty) {
          await db.delete('orders');
          await db.delete('consists');
        }
        orders.forEach((x) async {
          await db.insert('orders', x.toSQL());
          x.consists.forEach((y) async {
            return await db.insert('consists', y.toSQL());
          });
          return;
        });
        break;
      case 204:
        isOrdersEmpty = true;
        var sqlRes = await db.query('orders');
        if (sqlRes.isNotEmpty) {
          await db.delete('orders');
          await db.delete('consists');
        }
        break;
      default:
        (Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders')) == 0) ? isOrdersEmpty = true : isOrdersEmpty = false;
        connected = false;
        return;
    }
    response = await http.get(url + "/data/couriers", headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    if (response.statusCode != 200) {
      connected = false;
      return;
    } else {
      connected = true;
      couriers = couriersFromJson(response.body);
      var sqlRes = await db.query('couriers');
      if (sqlRes.isNotEmpty) {
        await db.delete('couriers');
      }
      await db.insert('couriers', couriers.toSQL());
    }
    response = await http.get(url + "/data/clients", headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    if (response.statusCode != 200) {
      connected = false;
      return;
    } else {
      connected = true;
      clients = clientsFromJson(response.body);
      var sqlRes = await db.query('clients');
      if (sqlRes.isNotEmpty) {
        await db.delete('clients');
      }
      clients.forEach((x) async {
        await db.insert('clients', x.toSQL(), conflictAlgorithm: ConflictAlgorithm.ignore);
        return;
      });
    }
  } catch (e) {
    print(e);
    (Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders')) == 0) ? isOrdersEmpty = true : isOrdersEmpty = false;
    connected = false;
    return;
  }
}

Color connectColor() {
  Color colorBackground;
  colorBackground = connected ? Colors.blueGrey : Colors.red;
  return colorBackground;
}

class ConnectToServer extends StatefulWidget {
  @override
  _ConnectToServerState createState() => _ConnectToServerState();
}

class _ConnectToServerState extends State<ConnectToServer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      builder: (context, startSnap) {
        if (startSnap.connectionState == ConnectionState.none || startSnap.connectionState == ConnectionState.waiting) {
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
              FlatButton(onPressed: () => SystemNavigator.pop(), child: Text('Выйти из программы')),
            ],
          );
        }
        if (token == 'Unconnect') {
          return AlertDialog(
            title: Text('Unconnect'),
            content: Text('Нет связи с сервером...\nДанные не актуальны.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Подключитьcя...'),
                onPressed: () => setState(() {}),
              ),
              FlatButton(
                child: Text('Продолжить'),
                onPressed: () {
                  setState(() => connected = false);
                  return Navigator.pushNamed(context, '/initDB');
                },
              ),
            ],
          );
        }
        // return OrdersPage(title: 'Заказы');
        // return InitDB();
        // Navigator.of(context).pushReplacementNamed('/initDB');
        return InitDB();
      },
      future: _fetchJWTToken(serverURL),
    );
  }
}

class InitDB extends StatefulWidget {
  @override
  _InitDBState createState() => _InitDBState();
}

class _InitDBState extends State<InitDB> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Database>(
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
        db = dbSnap.data;
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
      // home: ConnectToServer(),
      initialRoute: '/connectToServer',
      routes: {
        '/connectToServer': (context) => ConnectToServer(),
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
  var _listener;

  @override
  void initState() {
    super.initState();
    orderDelivered = 2;
    countTitle = countAll;
    DataConnectionChecker().addresses = [
      AddressCheckOptions(
        InternetAddress(serverAddress),
        port: serverPort,
      )
    ];
    _listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          print('Server available');
          setState(() => connected = true);
          break;
        case DataConnectionStatus.disconnected:
          print('Server unavailable');
          setState(() => connected = false);
          break;
      }
    });
  }

  @override
  void dispose() {
    // db.close();
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(mainTitle),
        backgroundColor: connectColor(),
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
              // onPressed: () {
              //   setState(() => connected = false);
              //   Timer(const Duration(seconds: 10),
              //       () => setState(() => connected = true));
              // },
              onPressed: () async {
                await _fetchDataToSQL(db, serverURL);
                countAll = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders'));
                countInWork = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 0'));
                countComplete = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = 1'));
                countDeffered = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM orders WHERE delivered = -1'));
                orderDelivered = 2;
                setState(() {});
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
      body: _orders.ordersListWidget(db, orderDelivered),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: _courier.courierCarNumber(db, macAddress),
              accountName: _courier.courierName(db, macAddress),
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
