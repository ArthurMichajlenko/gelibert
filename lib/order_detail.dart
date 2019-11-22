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
          children: <Widget>[
            Center(child: client.clientData(db, order.clientId)),
            Expanded(
              child: ListView.builder(
                itemCount: order.consists.length,
                itemBuilder: (context, index) {
                  return Card(
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
      // body: Center(
      //   child: RaisedButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: Text(order.consists[0].product),
      //   ),
      // ),
    );
  }
}
