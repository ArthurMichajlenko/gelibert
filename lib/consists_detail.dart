import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'main.dart';
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
  // var extInfoTo = List<String>();
  // var extInfoFrom = List<String>();

  // @override
  // initState() {
  //   if (extInfoTo.isEmpty) {
  //     for (var i = 0; i < widget.order.consistsTo.length; i++) {
  //       extInfoTo.add(widget.order.consistsTo[i].extInfo);
  //       // extInfoTo[i] = widget.order.consistsTo[i].extInfo;
  //     }
  //   }
  //   if (extInfoFrom.isEmpty) {
  //     for (var i = 0; i < widget.order.consistsFrom.length; i++) {
  //       extInfoFrom.add(widget.order.consistsFrom[i].extInfo);
  //       // extInfoFrom[i] = widget.order.consistsFrom[i].extInfo;
  //     }
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: connectColor(),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
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
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
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
                              setState(() {});
                            },
                          ),
                        ),
                      ),
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

//   Future scan() async {
//     try {
//       String code = await BarcodeScanner.scan();
//       setState(() => extInfo = code);
//     } on PlatformException catch (e) {
//       if (e.code == BarcodeScanner.CameraAccessDenied) {
//         setState(() => extInfo = 'Camera permission not granted');
//       } else {
//         setState(() => extInfo = 'Unknown error: $e');
//       }
//     } on FormatException {
//       setState(() => extInfo =
//           'null (User returned using the "back"-button before scanning anything)');
//     } catch (e) {
//       setState(() => extInfo = 'Unknown error: $e');
//     }
//     print(extInfo);
//   }
// }
  Future scan() async {
    String extInfo;
    try {
      String code = await BarcodeScanner.scan();
      extInfo = code;
    } catch (_) {}
    // print(extInfo);
    return extInfo;
  }
}
