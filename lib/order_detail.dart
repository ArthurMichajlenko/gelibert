import 'package:flutter/material.dart';
import 'models/orders.dart';
import 'models/clients.dart';
import 'main.dart';
import 'package:flutter_picker/flutter_picker.dart';

class OrderDetail extends StatefulWidget {
  final Orders order;

  OrderDetail({Key key, @required this.order}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final _scaffoldKey = GlobalKey();
  final Clients client = Clients();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Заказ № ${widget.order.id}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: client.clientData(db, widget.order.clientId),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Товар',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              title: Text('Общая сумма'),
              trailing: Text(
                widget.order.orderCost.toString() + ' Lei',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Divider(),
            for (int i = 0; i < widget.order.consists.length; i++)
              Column(
                children: [
                  ListTile(
                    title: Text(
                      (i + 1).toString() +
                          '. ' +
                          widget.order.consists[i].product,
                    ),
                    trailing: Text('Кол-во: \n' +
                        widget.order.consists[i].quantity.toString() +
                        ' шт.'),
                  ),
                  Divider(),
                ],
              ),
            Card(
              child: ListTile(
                title: Text(
                  'Оповестить клиента о доставке',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Picker picker = Picker(
                      looping: false,
                      hideHeader: true,
                      title: Text("Заказ будет доставлен через:"),
                      cancelText: 'Отменить',
                      confirmText: 'Отправить',
                      adapter: PickerDataAdapter(
                        data: [
                          PickerItem(
                            text: Text('15 минут'),
                            value: 15,
                          ),
                          PickerItem(
                            text: Text('30 минут'),
                            value: 30,
                          ),
                          PickerItem(
                            text: Text('1 час'),
                            value: 60,
                          ),
                          PickerItem(
                            text: Text('1,5 часа'),
                            value: 90,
                          ),
                          PickerItem(
                            text: Text('2 часа'),
                            value: 120,
                          ),
                        ],
                      ),
                      onConfirm: (Picker picker, List value) {
                        print(value);
                        print(picker.getSelectedValues()[0]);
                      });
                  // picker.show(_scaffoldKey.currentState);
                  picker.showDialog(context);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  'Связаться с клиентом',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
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
