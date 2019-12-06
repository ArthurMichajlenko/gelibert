import 'package:flutter/material.dart';
import 'models/orders.dart';

class ConsistsDetail extends StatelessWidget {
  final Orders order;

  ConsistsDetail({Key key, @required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ № ${order.id}'),
      ),
      body:  SingleChildScrollView(
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
                            (i + 1).toString() +
                                '. ' +
                                order.consistsTo[i].product,
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
                          title: Text(
                            (i + 1).toString() +
                                '. ' +
                                order.consistsFrom[i].product,
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
}
