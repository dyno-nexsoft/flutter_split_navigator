# flutter_split_view

[![Deploy Web](https://github.com/dyno-nexsoft/flutter_split_view/actions/workflows/deploy_web.yml/badge.svg)](https://github.com/dyno-nexsoft/flutter_split_view/actions/workflows/deploy_web.yml)

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

Add `flutter_split_view` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_split_view: ^1.0.0
```

---

## Usage

See the [`example`](example/lib/main.dart) for a complete usage example.

To use this package, add `flutter_split_view` as a [dependency in your pubspec.yaml file](https://dart.dev/tools/pub/cmd/pub-add).

For more details, please see the `example` directory.

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
