import 'package:flutter/widgets.dart';

import 'src/observers.dart';

/// A widget that creates a split view layout, showing two panels side-by-side
/// on wider screens and a single panel on narrower screens.
///
/// The [FlutterSplitView] widget is designed for responsive applications that
/// want to display a primary and secondary view. When the available width
/// exceeds the [breakpoint], both panels are shown side-by-side. On smaller
/// screens, only the primary panel is shown, and navigation is handled using
/// a secondary [Navigator].
///
/// The [placeholder] widget is displayed in the secondary panel when there are
/// no routes to show.
///
/// Example usage:
/// ```dart
/// FlutterSplitView(
///   breakpoint: 800,
///   placeholder: Center(child: Text('Select an item')),
///   onGenerateRoute: (settings) {
///     // Return your routes here.
///   },
/// )
/// ```
///
/// See also:
///  * [Navigator], which this widget extends.
///  * [LayoutBuilder], used internally for responsiveness.
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
    this.breakpoint = 600.0,
    this.placeholder = const Placeholder(),
  });

  /// The minimum width at which the split view displays both panels side-by-side.
  ///
  /// When the available width is greater than [breakpoint], the split view shows
  /// both the primary and secondary panels. Otherwise, only the primary panel is shown.
  final double breakpoint;

  /// The widget to show in the secondary panel when no route is pushed.
  ///
  /// This widget is displayed in the secondary panel when there are no routes
  /// in the secondary [Navigator]. By default, this is a [Placeholder] widget,
  /// but you can provide any widget, such as a message or illustration.
  final Widget placeholder;

  @override
  NavigatorState createState() => _FlutterSplitViewState();

  /// Returns the [NavigatorState] for the secondary panel from the closest
  /// [FlutterSplitView] ancestor of the given [context].
  ///
  /// This is useful for pushing or popping routes on the secondary panel's
  /// [Navigator]. Throws a [FlutterError] if no [FlutterSplitView] ancestor
  /// can be found in the widget tree.
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
    return LayoutBuilder(builder: (context, constraints) {
      final bool isSplit = constraints.maxWidth > widget.breakpoint;
      final double primaryWidth = widget.breakpoint / 2;
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
                        if (constraints.maxWidth > widget.breakpoint) {
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
