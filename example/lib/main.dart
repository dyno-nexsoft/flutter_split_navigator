import 'package:flutter/material.dart';
import 'package:flutter_split_navigator/flutter_split_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterSplitNavigator(
        breakpoint: 700,
        placeholder: const Material(
          child: Center(child: Text('Select an item')),
        ),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const MyScreen());
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            onTap: () => showAboutDialog(context: context),
            title: const Text('About dialog'),
          ),
          ListTile(
            onTap: () => Navigator.of(context).pushNamed('/'),
            title: const Text('Navigator push'),
          ),
          ListTile(
            onTap: () => FlutterSplitNavigator.of(context).pushNamed('/'),
            title: const Text('FlutterSplitNavigator push'),
          ),
        ],
      ),
    );
  }
}
