import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'models/orders.dart';
import 'package:barcode_scan/barcode_scan.dart';

class ConsistsDetail extends StatelessWidget {
  final Orders order;
  String serialNumber;

  ConsistsDetail({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: connectColor(),
        title: Text('Заказ № ${order.id}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Товар',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              title: Text('Общая сумма'),
              trailing: Text(
                order.orderCost.toString() + ' Lei',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Оплата ${order.paymentMethod}'),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Доставка клиенту',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
            Divider(),
            for (int i = 0; i < order.consistsTo.length; i++)
              Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    title: Text(
                      (i + 1).toString() + '. ' + order.consistsTo[i].product,
                    ),
                    subtitle: Text(
                        '${order.consistsTo[i].price}x${order.consistsTo[i].quantity} шт.'),
                    trailing: Text('Кол-во: \n' +
                        order.consistsTo[i].quantity.toString() +
                        ' шт.'),
                  ),
                  Divider(),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Возврат от клиента',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
            Divider(),
            for (int i = 0; i < order.consistsFrom.length; i++)
              Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    title: Text(
                      (i + 1).toString() + '. ' + order.consistsFrom[i].product,
                    ),
                    subtitle: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 1.0,
                          horizontal: 4.0,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'S/N',
                        suffixIcon: GestureDetector(
                          dragStartBehavior: DragStartBehavior.down,
                          child: Icon(Icons.scanner),
                          onTap: () => print('scan'),
                        ),
                      ),
                    ),
                    trailing: Text('Кол-во: \n' +
                        order.consistsFrom[i].quantity.toString() +
                        ' шт.'),
                  ),
                  Divider(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String code = await BarcodeScanner.scan();
      setState(()=>this.serialNumber=code)
    } catch (e) {}
  }
}
