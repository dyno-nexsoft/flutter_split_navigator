## Getting Started

Add `flutter_split_navigator` to your `pubspec.yaml` dependencies from GitHub:

```yaml
dependencies:
  flutter_split_navigator:
    git: https://github.com/dyno-nexsoft/flutter_split_navigator.git
```

---

## Usage

Import the package:

```dart
import 'package:flutter_split_navigator/flutter_split_navigator.dart';
```

Wrap your `MaterialApp` with `FlutterSplitNavigator` and provide an `onGenerateRoute` callback:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_split_navigator/flutter_split_navigator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterSplitNavigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const MyScreen(),
          );
        },
      ),
    );
  }
}
```

You can push routes to the secondary panel using:

```dart
FlutterSplitNavigator.of(context).pushNamed('/details');
```

---

## API

| Property          | Description                                                 | Default         |
| ----------------- | ----------------------------------------------------------- | --------------- |
| `breakpoint`      | Minimum width to show both panels side-by-side              | `600.0`         |
| `placeholder`     | Widget shown in the secondary panel when no route is pushed | `Placeholder()` |
| `onGenerateRoute` | Route generator for navigation in both panels               | _(required)_    |
