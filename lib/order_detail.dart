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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Clients client = Clients();

  final delays = const {
    15: '15 минут',
    30: '30 минут',
    60: '1 час',
    90: '1,5 часа',
    120: '2 часа',
  };

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Доставка клиенту',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            for (int i = 0; i < widget.order.consistsTo.length; i++)
              Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    title: Text(
                      (i + 1).toString() +
                          '. ' +
                          widget.order.consistsTo[i].product,
                    ),
                    subtitle: Text(
                        '${widget.order.consistsTo[i].price}x${widget.order.consistsTo[i].quantity} шт.'),
                    trailing: Text('Кол-во: \n' +
                        widget.order.consistsTo[i].quantity.toString() +
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
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            for (int i = 0; i < widget.order.consistsTo.length; i++)
              Column(
                children: [
                  ListTile(
                    title: Text(
                      (i + 1).toString() +
                          '. ' +
                          widget.order.consistsFrom[i].product,
                    ),
                    trailing: Text('Кол-во: \n' +
                        widget.order.consistsFrom[i].quantity.toString() +
                        ' шт.'),
                  ),
                  Divider(),
                ],
              ),
            if (widget.order.delivered != 1)
              Card(
                child: Builder(
                  builder: (context) => ListTile(
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
                              text: Text(delays[15]),
                              value: 15,
                            ),
                            PickerItem(
                              text: Text(delays[30]),
                              value: 30,
                            ),
                            PickerItem(
                              text: Text(delays[60]),
                              value: 60,
                            ),
                            PickerItem(
                              text: Text(delays[90]),
                              value: 90,
                            ),
                            PickerItem(
                              text: Text(delays[120]),
                              value: 120,
                            ),
                          ],
                        ),
                        onConfirm: (Picker picker, List value) async {
                          await db.update('orders',
                              {'delivery_delay': picker.getSelectedValues()[0]},
                              where: 'id=?', whereArgs: [widget.order.id]);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      'SMS: Ваш заказ будет доставлен через ${delays[picker.getSelectedValues()[0]]} на номер',
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                  client.clientTel(db, widget.order.clientId),
                                ],
                              ),
                              duration: Duration(
                                seconds: 3,
                              ),
                            ),
                          );
                        },
                        onCancel: () async {
                          await db.update('orders', {'delivery_delay': 0},
                              where: 'id=?', whereArgs: [widget.order.id]);
                        },
                      );
                      // picker.show(_scaffoldKey.currentState);
                      picker.showDialog(context);
                    },
                  ),
                ),
              ),
            Card(
              child: Builder(
                builder: (context) => ListTile(
                  title: Text(
                    'Связаться с клиентом',
                    style: TextStyle(
                      color: Colors.lightBlue,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Связаться с клиентом'),
                          content: Row(
                            children: <Widget>[
                              Text('Позвонить клиенту '),
                              client.clientName(db, widget.order.clientId),
                              Text(' ?'),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Нет'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('Да'),
                              onPressed: () {
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: <Widget>[ 
                                        Text('Звонок на номер: '),
                                        client.clientTel(
                                            db, widget.order.clientId),
                                      ],
                                    ),
                                    duration: Duration(
                                      seconds: 3,
                                    ),
                                  ),
                                );
                                return Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white70,
        onTap: (index) {
          switch (index) {
            case 0:
              if (widget.order.delivered == -1) {
                noActionDialog(context, 'отложен');
              } else if (widget.order.delivered == 1) {
                noActionDialog(context, 'завершен');
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Отложить заказ'),
                      content: Text("Вы уверены ?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Нет'),
                          onPressed: () {
                            Navigator.pop(context);
                            return Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('Да'),
                          onPressed: () async {
                            setState(() {
                              countInWork--;
                              countDeffered++;
                            });
                            await db.update('orders', {'delivered': -1},
                                where: 'id=?', whereArgs: [widget.order.id]);
                            Navigator.pop(context);
                            return Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              break;
            case 1:
              if (widget.order.delivered == 1) {
                noActionDialog(context, 'завершен');
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Завершить заказ'),
                      content: Text("Вы уверены ?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Нет'),
                          onPressed: () {
                            Navigator.pop(context);
                            return Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('Да'),
                          onPressed: () async {
                            String _dt = DateTime.now().toLocal().toString();
                            int _indexMS = _dt.indexOf('.');
                            setState(() {
                              if (widget.order.delivered == -1) {
                                countDeffered--;
                                countComplete++;
                              } else {
                                countInWork--;
                                countComplete++;
                              }
                            });
                            _dt = _dt.substring(0, _indexMS);
                            await db.update(
                                'orders',
                                {
                                  'delivered': 1,
                                  'date_finish': _dt,
                                },
                                where: 'id=?',
                                whereArgs: [widget.order.id]);
                            Navigator.pop(context);
                            return Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
              break;
            default:
          }
        },
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

  Future noActionDialog(BuildContext context, String reason) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Заказ $reason',
              style: TextStyle(color: Colors.red),
            ),
            content:
                Text('Заказ $reason. Данное действие для него не доступно.'),
            actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.do_not_disturb_alt),
                label: Text('Вернуться'),
                textColor: Colors.red,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
