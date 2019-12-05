import 'package:flutter/material.dart';

class TitleOrders extends StatefulWidget {
  final int _counter;
  final int _counterAll;
  final int _delivered;

  TitleOrders(this._counter, this._counterAll, this._delivered);

  @override
  _TitleOrdersState createState() => _TitleOrdersState();
}

class _TitleOrdersState extends State<TitleOrders> {
  @override
  Widget build(BuildContext context) {
    String _textTitle;
    Color _colorCounter;
    Color _colorCounterAll = Colors.black;

    switch (widget._delivered) {
      case -1:
        _textTitle = 'Заказы отложенные ';
        _colorCounter = Colors.red;
        break;
      case 0:
        _textTitle = 'Заказы в работе ';
        _colorCounter = Colors.blue;
        break;
      case 1:
        _textTitle = 'Заказы выполненные ';
        _colorCounter = Colors.green;
        break;
      default:
        _textTitle = 'Заказы ';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(_textTitle),
        Chip(
          backgroundColor: Colors.white,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget._delivered == -1 ||
                  widget._delivered == 0 || 
                  widget._delivered == 1)
                Text(
                  '${widget._counter}',
                  style: TextStyle(
                    color: _colorCounter,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (widget._delivered == -1 ||
                  widget._delivered == 0 || 
                  widget._delivered == 1)
              Text('/'),
              Text(
                '${widget._counterAll}',
                style: TextStyle(
                  color: _colorCounterAll,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
