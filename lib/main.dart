// import 'dart:io';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gilebert/models/geodata.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'models/orders.dart';
import 'models/couriers.dart';
import 'title_orders.dart';
import 'package:gilebert/exchange.dart';
import 'auth_page.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

// void main() => runApp(GelibertApp());
Database db;
String token = 'Notoken';
String macAddress;
// Couriers courier;
// DevServer work
final serverProtocol = 'http';
// Local
final serverAddress = '10.10.11.156';
// Office MoldTelecom
// final serverAddress = '188.237.114.90';
final serverPort = 1323;
final serverURL = serverProtocol + '://' + serverAddress + ':' + serverPort.toString();
bool connected = false;
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
  await fetchDataToSQL(db, serverURL);
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
  await saveGeodata(db, macAddress, serverURL);
  // Timer.periodic(Duration(minutes: 5), (Timer timer) => saveGeodata(db, macAddress, serverURL));
  // Geolocator.getCurrentPosition().then((value) => db.insert('geodata', {
  //       'longitude': value.longitude,
  //       'latitude': value.latitude,
  //     }));
}

Future<String> _fetchJWTToken(String url) async {
  if (token == 'Notoken' || token == 'Unconnect') {
    try {
      var res = await http.post(url + "/login", body: {'macAddress': macAddress});
      if (res.statusCode != HttpStatus.ok) {
        connected = false;
        return "Unauthorized";
      }
      Map<String, dynamic> tk = jsonDecode(res.body);
      connected = true;
      token = tk['token'];
      // return token;
      // return tk['token'];
      // } on SocketException catch (e) {
    } catch (_) {
      connected = false;
      return "Unconnect";
    }
  }
  return token;
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
        if (token == 'Unauthorized') {
          return AlertDialog(
            title: Text('Unauthorized'),
            content: Text('ID отсутствует в системе...'),
            actions: <Widget>[
              FlatButton(onPressed: () => SystemNavigator.pop(), child: Text('Выйти из программы')),
            ],
          );
        }
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
  var _listener;

  @override
  void initState() {
    super.initState();
    // Write geodtat to SQL every 5 min
    Timer.periodic(Duration(minutes: 5), (Timer timer) => saveGeodata(db, macAddress, serverURL));
    // Timer.periodic(Duration(minutes: 5), (Timer timer) {
    //   Geolocator.getCurrentPosition().then((value) => db.insert('geodata', {
    //         'longitude': value.longitude,
    //         'latitude': value.latitude,
    //       }));
    // });
    // Check connection with backend server
    DataConnectionChecker().addresses = [
      AddressCheckOptions(
        InternetAddress(serverAddress),
        port: serverPort,
      )
    ];
    _listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          setState(() => connected = true);
          break;
        case DataConnectionStatus.disconnected:
          setState(() => connected = false);
          break;
      }
    });
  }

  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orders',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      // initialRoute: '/connectToServer',
      initialRoute: '/authPage',
      routes: {
        '/connectToServer': (context) => ConnectToServer(),
        '/initDB': (context) => InitDB(),
        '/ordersPage': (context) => OrdersPage(title: 'Заказы'),
        '/authPage': (context) => AuthPage(),
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
              // onPressed: () {
              //   setState(() => connected = false);
              //   Timer(const Duration(seconds: 10),
              //       () => setState(() => connected = true));
              // },
              onPressed: () async {
                await fetchDataToSQL(db, serverURL);
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
        // bottom: PreferredSize(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text(
        //       'Маршрутный лист № 000080258',
        //       style: TextStyle(
        //         fontSize: 14,
        //         color: Colors.white,
        //         fontStyle: FontStyle.italic,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        //   preferredSize: Size.fromHeight(10),
        // ),
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
                      await fetchDataToSQL(db, serverURL);
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
                // if (!connected) {
                //   AlertDialog(
                //     title: Text('Connect'),
                //     content: Text('Нет соединения с сервером'),
                //     actions: <Widget>[
                //       FlatButton(onPressed: () => Navigator.pop(context), child: Text('Ok'),),
                //     ],
                //   );
                // }
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
