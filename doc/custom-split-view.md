## Usage custom split view

This document provides an example of how to create a custom split view using the `SplitHandler` mixin. By extending `StatefulWidget` and mixing in `SplitHandler`, you gain fine-grained control over the primary and secondary panels, their navigation, and responsive behavior.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_split_view/flutter_split_view.dart';

class CustomSplitView extends StatefulWidget {
  const CustomSplitView({super.key, required this.child});

  final Widget child;

  @override
  State<CustomSplitView> createState() => _State();
}

class _State extends State<CustomSplitView> with SplitHandler {
  final _secondaryKey = GlobalKey<NavigatorState>();
  late final _secondaryObserver = FlutterSplitNavigatorObserver(setState);

  @override
  double get breakpoint => 600;

  @override
  bool canPop() => _secondaryKey.currentState?.canPop() ?? false;

  @override
  Widget build(BuildContext context) {
    return super.buildBody(context);
  }

  @override
  Widget buildPrimary(BuildContext context) {
    return widget.child;
  }

  @override
  Widget buildSecondary(BuildContext context) {
    return Navigator(
      key: _secondaryKey,
      observers: [_secondaryObserver],
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return ValueListenableBuilder<bool>(
                valueListenable: isSplit,
                builder: (context, value, child) {
                  if (value) return child!;
                  return const SizedBox.shrink();
                },
                child: const Placeholder(),
              );
            },
          )
        ];
      },
    );
  }
}
```

### Explanation of the `CustomSplitView`

The `CustomSplitView` class demonstrates how to implement a custom split view by extending `StatefulWidget` and mixing in the `SplitHandler` mixin.

-   **`SplitHandler` Mixin**: This mixin provides the core logic for managing the split view's state, including determining if the view is currently split (`isSplit`) and handling navigation between primary and secondary panels.

-   **`_secondaryKey` and `_secondaryObserver`**:
    -   `_secondaryKey`: A `GlobalKey` used to access the `NavigatorState` of the secondary panel's `Navigator`. This is crucial for managing navigation within the secondary view.
    -   `_secondaryObserver`: An instance of `FlutterSplitNavigatorObserver`, which is a custom `NavigatorObserver` that triggers a rebuild of the `CustomSplitView` when routes change in the secondary navigator. This ensures the UI updates correctly when navigating within the secondary panel.

-   **`breakpoint` Getter**:
    -   `@override double get breakpoint => 600;`: This property defines the minimum width (in logical pixels) at which both the primary and secondary panels will be displayed side-by-side. If the screen width is less than this breakpoint, only one panel will be visible at a time, and navigation will switch between them.

-   **`canPop()` Method**:
    -   `@override bool canPop() => _secondaryKey.currentState?.canPop() ?? false;`: This method is overridden from `SplitHandler` and is used to determine if the secondary navigator can pop its current route. This is important for handling the back button behavior in a split view, allowing the secondary panel to navigate back before the entire split view is popped.

-   **`buildPrimary(BuildContext context)` Method**:
    -   `@override Widget buildPrimary(BuildContext context) { return widget.child; }`: This method is responsible for building the content of the primary panel. In this example, it simply returns the `child` widget passed to the `CustomSplitView`.

-   **`buildSecondary(BuildContext context)` Method**:
    -   `@override Widget buildSecondary(BuildContext context) { ... }`: This method builds the content of the secondary panel. It wraps its content in a `Navigator` widget, allowing for independent navigation within the secondary panel.
    -   **`Navigator`**: The secondary panel uses its own `Navigator` with `_secondaryKey` and `_secondaryObserver` to manage its navigation stack.
    -   **`onGenerateInitialRoutes`**: This callback is used to define the initial route(s) for the secondary navigator. In this example, it creates a `PageRouteBuilder` that conditionally displays a `Placeholder` widget based on the `isSplit` value.
    -   **`ValueListenableBuilder<bool> isSplit`**: The `isSplit` value notifier, provided by `SplitHandler`, indicates whether the split view is currently in a split (two-panel) layout or a single-panel layout. The `ValueListenableBuilder` rebuilds its child (the `Placeholder` in this case) only when `isSplit` changes, ensuring efficient UI updates. When `isSplit` is true, the `Placeholder` is shown; otherwise, a `SizedBox.shrink()` is returned, effectively hiding the secondary content when not in split mode.
