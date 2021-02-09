import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'main.dart';
// import 'models/couriers.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String courierID;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Регистрация ...'),
          ),
          body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Введите свой ID',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: courierID,
                    validator: courierIDValidator,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                      fontSize: 24,
                    ),
                    onFieldSubmitted: (value) {
                      if (_formKey.currentState.validate()) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(courierID + 'value' + value)));
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: RaisedButton(
                        child: Text('Зарегистрироваться'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(courierID)));
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  String courierIDValidator(value) {
    if (value.isEmpty) {
      return 'Заполните свой ID';
    }
    courierID = value;
    return null;
  }
}
