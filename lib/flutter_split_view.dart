import 'package:flutter/widgets.dart';

import 'src/observers.dart';

/// A widget that creates a split view layout, showing two panels side-by-side
/// on wider screens and a single panel on narrower screens.
class FlutterSplitView extends Navigator {
  /// Creates a split view layout.
  const FlutterSplitView({
    super.key,
    super.pages,
    super.initialRoute,
    super.onGenerateInitialRoutes,
    super.onGenerateRoute,
    super.restorationScopeId,
    super.observers,
    super.onDidRemovePage,
    this.breakPoint = 600.0,
    this.placeholder = const Placeholder(),
  });

  final double breakPoint;

  /// The widget to show in the secondary panel when no route is pushed.
  final Widget placeholder;

  @override
  NavigatorState createState() => _FlutterSplitViewState();

  /// The state from the closest instance of this class that encloses the given
  /// context.
  static NavigatorState of(BuildContext context) {
    _FlutterSplitViewState? navigator;
    if (context is StatefulElement && context.state is _FlutterSplitViewState) {
      navigator = context.state as _FlutterSplitViewState;
    }
    navigator ??= context.findAncestorStateOfType<_FlutterSplitViewState>();

    assert(() {
      if (navigator == null) {
        throw FlutterError(
          'Navigator operation requested with a context that does not include a Navigator.\n'
          'The context used to push or pop routes from the Navigator must be that of a '
          'widget that is a descendant of a Navigator widget.',
        );
      }
      return true;
    }());
    return navigator!._secondaryKey.currentState!;
  }
}

class _FlutterSplitViewState extends NavigatorState {
  final _secondaryKey = GlobalKey<NavigatorState>();

  @override
  FlutterSplitView get widget => super.widget as FlutterSplitView;

  @override
  Widget build(BuildContext context) {
    StatefulBuilder;
    return LayoutBuilder(builder: (context, constraints) {
      final bool isSplit = constraints.maxWidth > widget.breakPoint;
      final double primaryWidth = widget.breakPoint / 2;
      final double secondaryLeft, secondaryWidth;
      if (isSplit == false) {
        final canPop = _secondaryKey.currentState?.canPop();
        if (canPop == true) {
          secondaryLeft = 0;
          secondaryWidth = constraints.maxWidth;
        } else {
          secondaryLeft = constraints.maxWidth;
          secondaryWidth = constraints.maxWidth;
        }
      } else {
        secondaryLeft = primaryWidth;
        secondaryWidth = constraints.maxWidth - primaryWidth;
      }

      return Stack(
        children: [
          Positioned(
            left: 0,
            width: isSplit ? primaryWidth : constraints.maxWidth,
            height: constraints.maxHeight,
            child: super.build(context),
          ),
          Positioned(
            left: secondaryLeft,
            width: secondaryWidth,
            height: constraints.maxHeight,
            child: Navigator(
              key: _secondaryKey,
              observers: [
                FlutterSplitRouteObserver(setState),
                ...widget.observers
              ],
              onGenerateInitialRoutes: (navigator, initialRoute) {
                return [
                  PageRouteBuilder(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth > widget.breakPoint) {
                          return widget.placeholder;
                        }
                        return const SizedBox.shrink();
                      });
                    },
                  )
                ];
              },
              onGenerateRoute: widget.onGenerateRoute,
            ),
          ),
        ],
      );
    });
  }
}
