import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'main.dart';
import 'models/orders.dart';
import 'package:barcode_scan/barcode_scan.dart';

class ConsistsDetail extends StatefulWidget {
  final Orders order;

  ConsistsDetail({Key key, @required this.order}) : super(key: key);

  @override
  _ConsistsDetailState createState() => _ConsistsDetailState();
}

class _ConsistsDetailState extends State<ConsistsDetail> {
  // String extInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: connectColor(),
        title: Text('Заказ № ${widget.order.id}'),
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
                widget.order.orderCost.toString() + ' Lei',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('Оплата ${widget.order.paymentMethod}'),
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              '${widget.order.consistsTo[i].price}x${widget.order.consistsTo[i].quantity} шт.'),
                        ),
                        if (widget.order.delivered == 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.order.consistsTo[i].extInfo),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              onSubmitted: (text) async {
                                widget.order.consistsTo[i].extInfo = text;
                                await db.update(
                                    'consists_to',
                                    {
                                      'ext_info':
                                          widget.order.consistsTo[i].extInfo,
                                    },
                                    where: 'id=? AND di=?',
                                    whereArgs: [
                                      widget.order.id,
                                      widget.order.consistsTo[i].di
                                    ]);
                              },
                              controller: TextEditingController(
                                text: widget.order.consistsTo[i].extInfo,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 1.0,
                                  horizontal: 4.0,
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Доп.инф (S/N...)',
                                suffixIcon: GestureDetector(
                                  dragStartBehavior: DragStartBehavior.down,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ),
                                  onTap: () async {
                                    widget.order.consistsTo[i].extInfo =
                                        await scan();
                                    await db.update(
                                        'consists_to',
                                        {
                                          'ext_info': widget
                                              .order.consistsTo[i].extInfo,
                                        },
                                        where: 'id=? AND di=?',
                                        whereArgs: [
                                          widget.order.id,
                                          widget.order.consistsTo[i].di
                                        ]);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
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
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
            Divider(),
            for (int i = 0; i < widget.order.consistsFrom.length; i++)
              Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    title: Text(
                      (i + 1).toString() +
                          '. ' +
                          widget.order.consistsFrom[i].product,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (widget.order.delivered == 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.order.consistsFrom[i].extInfo),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onSubmitted: (text) async {
                                widget.order.consistsFrom[i].extInfo = text;
                                await db.update(
                                    'consists_from',
                                    {
                                      'ext_info':
                                          widget.order.consistsFrom[i].extInfo,
                                    },
                                    where: 'id=? AND di=?',
                                    whereArgs: [
                                      widget.order.id,
                                      widget.order.consistsFrom[i].di
                                    ]);
                              },
                              controller: TextEditingController(
                                text: widget.order.consistsFrom[i].extInfo,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 1.0,
                                  horizontal: 4.0,
                                ),
                                border: OutlineInputBorder(),
                                labelText: 'Доп.инф (S/N...)',
                                suffixIcon: GestureDetector(
                                  dragStartBehavior: DragStartBehavior.down,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                  ),
                                  onTap: () async {
                                    widget.order.consistsFrom[i].extInfo =
                                        await scan();
                                    await db.update(
                                        'consists_from',
                                        {
                                          'ext_info': widget
                                              .order.consistsFrom[i].extInfo,
                                        },
                                        where: 'id=? AND di=?',
                                        whereArgs: [
                                          widget.order.id,
                                          widget.order.consistsFrom[i].di
                                        ]);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    trailing: Text('Кол-во: \n' +
                        widget.order.consistsFrom[i].quantity.toString() +
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
    String extInfo;
    try {
      String code = await BarcodeScanner.scan();
      extInfo = code;
    } catch (_) {}
    return extInfo;
  }
}
