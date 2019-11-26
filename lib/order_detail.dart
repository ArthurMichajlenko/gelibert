import 'package:flutter/material.dart';
import 'models/orders.dart';
import 'models/clients.dart';
import 'main.dart';

class OrderDetail extends StatelessWidget {
  final Orders order;
  final Clients client = Clients();
  OrderDetail({Key key, @required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrderDetail"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: client.clientData(db, order.clientId),
            ),
            Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: order.consists.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemBuilder: (context, index) {
                  return Container(
                    child: ListTile(
                      // isThreeLine: true,
                      title: Text(order.consists[index].product),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.av_timer,
              color: Colors.red,
            ),
            title: Text(
              'Отложить',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            title: Text(
              'Завершить',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
