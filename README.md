# flutter_split_view

[![Deploy Web](https://github.com/dyno-nexsoft/flutter_split_view/actions/workflows/deploy_web.yml/badge.svg)](https://github.com/dyno-nexsoft/flutter_split_view/actions/workflows/deploy_web.yml)

A Flutter widget that creates a split view layout, showing two panels side-by-side on wider screens and a single panel on narrower screens.

## Usage

To use this package, add `flutter_split_view` as a [dependency in your pubspec.yaml file](https://flutter.dev/to/add-a-dependency).

Then, you can use the `FlutterSplitView` widget in your app. Here is a simple example:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_split_view/flutter_split_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterSplitView(
        placeholder: Center(
          child: Text('Placeholder'),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => Text('Main Page'));
            default:
              return MaterialPageRoute(builder: (context) => Text('Unknown Page'));
          }
        },
      ),
    );
  }
}
```

For a more detailed example, please see the `example` directory.