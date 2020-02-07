import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MethodChannel API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter MethodChannel API Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MethodChannel _channel = const MethodChannel('com.example.methodchannel/interop');
  String _platformMessage;

  static Future<String> get _platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Null> get _number async {
    final int number = await _channel.invokeMethod('getNumber');
    print(number);
  }

  static Future<Null> _callMe() async {
    await _channel.invokeMethod('callMe');
  }

  static Future<dynamic> get _list async {
    final Map params = <String, dynamic> {
      "name": "my name is hoge",
      "age": 25,
    };
    final List<dynamic> list = await _channel.invokeMethod('getList', params);
    return list;
  }

  Future platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "callMe":
        print('call callMe : arguments = ${call.arguments}');
        break;
      default:
        print('Unknowm method ${call.method}');
    }
  }

  @override
  initState() {
    super.initState();

    // Platforms -> Dart
    _channel.setMethodCallHandler(platformCallHandler);

    // Dart -> Platforms
    _platformVersion.then((value) => setState(() => _platformMessage = value));
    _number.then((value) => null);
    _list.then((value) => print(value));
    _callMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Platform: $_platformMessage',
            ),
          ],
        ),
      ),
    );
  }
}
