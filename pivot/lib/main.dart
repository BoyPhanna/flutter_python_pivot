import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Python in Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const platform = MethodChannel('python_channel');

  Future<void> _runPythonScript(BuildContext context) async {
    String greeting;
    try {
      greeting = await platform.invokeMethod('runPythonScript');
    } on PlatformException catch (e) {
      greeting = "Failed to get greeting: '${e.message}'.";
    }

    // Show the result in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Greeting'),
        content: Text(greeting),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Run Python Script'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _runPythonScript(context);
          },
          child: Text('Run Python Script'),
        ),
      ),
    );
  }
}
