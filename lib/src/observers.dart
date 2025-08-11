import 'package:flutter/widgets.dart';

/// A [NavigatorObserver] that calls a [StateSetter] whenever the navigation stack changes.
///
/// This observer is useful for widgets that need to update their state in response
/// to navigation events such as push, pop, or remove.
class FlutterSplitNavigatorObserver extends NavigatorObserver {
  /// Creates a [FlutterSplitNavigatorObserver] with the given [setState] callback.
  ///
  /// The [setState] callback will be called after navigation events to trigger a rebuild.
  FlutterSplitNavigatorObserver(this.setState);

  /// The callback used to update the widget's state.
  final StateSetter setState;

  /// Schedules a call to [setState] after the current frame.
  void _update() => WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });

  /// Called when a route has been popped off the navigator.
  ///
  /// Schedules a state update after the route's reverse transition duration.
  @override
  void didPop(Route route, Route? previousRoute) {
    final Duration transitionDuration;
    if (route is ModalRoute) {
      transitionDuration = route.reverseTransitionDuration;
    } else {
      transitionDuration = Duration.zero;
    }
    Future.delayed(transitionDuration, _update);
  }

  /// Called when a route has been pushed onto the navigator.
  ///
  /// Triggers a state update after the frame.
  @override
  void didPush(Route route, Route? previousRoute) => _update();

  /// Called when a route has been removed from the navigator.
  ///
  /// Triggers a state update after the frame.
  @override
  void didRemove(Route route, Route? previousRoute) => _update();
}
