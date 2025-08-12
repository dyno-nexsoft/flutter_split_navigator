# flutter_split_view

[![Deploy Web](https://github.com/dyno-nexsoft/flutter_split_view/actions/workflows/deploy_web.yml/badge.svg)](https://github.com/dyno-nexsoft/flutter_split_view/actions/workflows/deploy_web.yml)
[![GitHub issues](https://img.shields.io/github/issues/dyno-nexsoft/flutter_split_view.svg)](https://github.com/dyno-nexsoft/flutter_split_view/issues)

A Flutter widget for building responsive split view layouts. Show two panels side-by-side on wide screens, and a single panel with secondary navigation on narrow screens.

---

## Features

- Responsive split view: automatically adapts to screen width.
- Primary and secondary navigation using two [Navigator]s.
- Customizable breakpoint for switching layouts.
- Placeholder widget for the secondary panel.
- Easy integration with existing navigation logic.

---

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
```

To push a new route to the secondary panel, use `FlutterSplitView.of(context).pushNamed('/your-route')`.

---

## API

### `FlutterSplitView`

| Property          | Description                                                 | Default         |
| ----------------- | ----------------------------------------------------------- | --------------- |
| `breakpoint`      | Minimum width to show both panels side-by-side              | `600.0`         |
| `placeholder`     | Widget shown in the secondary panel when no route is pushed | `Placeholder()` |
| `onGenerateRoute` | Route generator for navigation in both panels               | _(required)_    |

#### Accessing the secondary navigator

You can push routes to the secondary panel using:

```dart
FlutterSplitView.of(context).pushNamed('/details');
```

---

## Example

See the [`example`](example) directory for a complete app.

---

## License

MIT © 2025
