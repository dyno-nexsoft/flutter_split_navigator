import 'package:flutter/material.dart';
import 'package:flutter_split_view/flutter_split_view.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: FlutterSplitView(
        breakpoint: 700,
        placeholder: const Material(
          child: Center(
            child: Text('Select an item'),
          ),
        ),
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
