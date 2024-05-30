import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frb_test_1/src/rust/api/simple.dart';
import 'package:frb_test_1/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

final Future<String> _calculation = Future<String>.delayed(
  const Duration(seconds: 2),
  () => 'Data Loaded',
);

Future<List<String>> _getFiles() async {
  final dir = Directory('/home/fabian');
  final List<FileSystemEntity> entities = await dir.list().toList();
  return entities.map((e) => e.path).toList();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return Text(
                  'List item $index',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ),
          Text(
            'Action: Calling into Rust...\nResult: ${greet(name: "InputName")}',
          ),
          FutureBuilder<List<String>>(
            future: _getFiles(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                var files = snapshot.data!..sort();
                return Expanded(
                  child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return Text(
                        files[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            },
          )
        ]),
      ),
    );
  }
}
