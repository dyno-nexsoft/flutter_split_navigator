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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed('/'),
              child: const Text('Navigator push'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => FlutterSplitView.of(context).pushNamed('/'),
              child: const Text('FlutterSplitView push'),
            ),
          ],
        ),
      ),
    );
  }
}
