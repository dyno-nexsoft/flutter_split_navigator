import 'package:flutter/material.dart';
import 'package:flutter_split_view/flutter_split_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterSplitView(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const MyScreen(),
          );
        },
      ),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example split view')),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          if (index.isEven) {
            return ListTile(
              onTap: () => Navigator.of(context).pushNamed('/'),
              title: const Text('Navigator push'),
            );
          } else {
            return ListTile(
              onTap: () => FlutterSplitView.of(context).pushNamed('/'),
              title: const Text('FlutterSplitView push'),
            );
          }
        },
      ),
    );
  }
}
