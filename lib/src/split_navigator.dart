import 'package:flutter/widgets.dart';

import 'split_observers.dart';
import 'split_handler.dart';

/// A widget that creates a split view layout, showing two panels side-by-side
/// on wider screens and a single panel on narrower screens.
///
/// The [FlutterSplitNavigator] widget is designed for responsive applications that
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
/// FlutterSplitNavigator(
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
class FlutterSplitNavigator extends Navigator {
  /// Creates a split view layout.
  const FlutterSplitNavigator({
    super.key,
    super.initialRoute,
    super.onGenerateInitialRoutes,
    super.onGenerateRoute,
    super.onUnknownRoute,
    super.transitionDelegate,
    super.reportsRouteUpdateToEngine,
    super.clipBehavior,
    super.observers,
    super.requestFocus,
    super.restorationScopeId,
    super.routeTraversalEdgeBehavior,
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
  NavigatorState createState() => _FlutterSplitNavigatorState();

  /// Returns the [NavigatorState] for the secondary panel from the closest
  /// [FlutterSplitNavigator] ancestor of the given [context].
  ///
  /// This is useful for pushing or popping routes on the secondary panel's
  /// [Navigator]. Throws a [FlutterError] if no [FlutterSplitNavigator] ancestor
  /// can be found in the widget tree.
  static NavigatorState of(BuildContext context) {
    return _of(context)._secondaryObserver.navigator!;
  }

  /// Returns `true` if the [FlutterSplitNavigator] ancestor of the given [context]
  /// is currently displaying both panels side-by-side (split mode).
  ///
  /// This can be used to determine whether the split view is active, based on
  /// the current layout constraints and the [breakpoint] value.
  ///
  /// Example:
  /// ```dart
  /// final isSplit = FlutterSplitNavigator.isSplitOf(context);
  /// ```
  static bool isSplitOf(BuildContext context) {
    return _of(context).isSplit;
  }
}

class _FlutterSplitNavigatorState extends NavigatorState
    with FlutterSplitHandler {
  late final _secondaryObserver = FlutterSplitObserver();

  @override
  FlutterSplitNavigator get widget => super.widget as FlutterSplitNavigator;

  @override
  double get breakpoint => widget.breakpoint;

  @override
  bool canPop() => _secondaryObserver.canPop();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _secondaryObserver,
      builder: (context, child) {
        return super.buildSplit(context);
      },
    );
  }

  @override
  Widget buildPrimary(BuildContext context) {
    return super.build(context);
  }

  @override
  Widget buildSecondary(BuildContext context) {
    return Navigator(
      observers: [_secondaryObserver, ...widget.observers],
      onGenerateInitialRoutes: (navigator, initialRoute) {
        return [
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return Builder(
                builder: (context) {
                  if (FlutterSplitNavigator.isSplitOf(context)) {
                    return widget.placeholder;
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          )
        ];
      },
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onUnknownRoute: widget.onUnknownRoute,
      transitionDelegate: widget.transitionDelegate,
      reportsRouteUpdateToEngine: widget.reportsRouteUpdateToEngine,
      clipBehavior: widget.clipBehavior,
      requestFocus: widget.requestFocus,
      restorationScopeId: widget.restorationScopeId,
      routeTraversalEdgeBehavior: widget.routeTraversalEdgeBehavior,
      onDidRemovePage: widget.onDidRemovePage,
    );
  }
}

_FlutterSplitNavigatorState _of(BuildContext context) {
  _FlutterSplitNavigatorState? navigator;
  if (context is StatefulElement &&
      context.state is _FlutterSplitNavigatorState) {
    navigator = context.state as _FlutterSplitNavigatorState;
  }
  navigator ??= context.findAncestorStateOfType<_FlutterSplitNavigatorState>();

  assert(() {
    if (navigator == null) {
      throw FlutterError(
        'FlutterSplitNavigator operation requested with a context that does not include a FlutterSplitNavigator.\n'
        'The context used to push or pop routes from the FlutterSplitNavigator must be that of a '
        'widget that is a descendant of a FlutterSplitNavigator widget.',
      );
    }
    return true;
  }());
  return navigator!;
}
