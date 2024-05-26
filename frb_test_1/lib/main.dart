import 'package:flutter/material.dart';
import 'package:frb_test_1/src/rust/api/simple.dart';
import 'package:frb_test_1/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Center(
          child: Text(
              'Action: Calling into Rust...\nResult: ${greet(name: "InputName")}'),
        ),
      ),
    );
  }
}
