## Getting Started

Add `flutter_split_view` to your `pubspec.yaml` dependencies from GitHub:

```yaml
dependencies:
  flutter_split_view:
    git: https://github.com/dyno-nexsoft/flutter_split_view.git
```

---

## Usage

Import the package:

```dart
import 'package:flutter_split_view/flutter_split_view.dart';
```

Wrap your `MaterialApp` with `FlutterSplitView` and provide an `onGenerateRoute` callback:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_split_view/flutter_split_view.dart';

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
```

You can push routes to the secondary panel using:

```dart
FlutterSplitView.of(context).pushNamed('/details');
```

---

## API

| Property          | Description                                                 | Default         |
| ----------------- | ----------------------------------------------------------- | --------------- |
| `breakpoint`      | Minimum width to show both panels side-by-side              | `600.0`         |
| `placeholder`     | Widget shown in the secondary panel when no route is pushed | `Placeholder()` |
| `onGenerateRoute` | Route generator for navigation in both panels               | _(required)_    |
