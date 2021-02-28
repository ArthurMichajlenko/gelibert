import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      builder: (context, startSnap) {
        if (startSnap.connectionState == ConnectionState.none || startSnap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Регистрация..."),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (startSnap.data.length == 0) {
          return buildAuthPage(context);
        }
        macAddress = startSnap.data[0]['mac_address'];
        return ConnectToServer();
      },
      future: db.query(
        'couriers',
        columns: ['mac_address'],
      ),
    );
  }

  GestureDetector buildAuthPage(BuildContext context) {
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (connected)
                inputIdForm(context)
              else
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Подключение к серверу...',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                            )),
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }

  Form inputIdForm(BuildContext context) {
    return Form(
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
              initialValue: macAddress,
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
                  Navigator.pushNamed(context, '/connectToServer');
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
                      Navigator.pushNamed(context, '/connectToServer');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String courierIDValidator(value) {
    if (value.isEmpty) {
      return 'Заполните свой ID';
    }
    setState(() {
      macAddress = value;
      token = 'Notoken';
    });
    return null;
  }
}
