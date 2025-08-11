import 'package:flutter/widgets.dart';

class FlutterSplitRouteObserver extends NavigatorObserver {
  FlutterSplitRouteObserver(this.setState);

  final StateSetter setState;

  void _update() => WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });

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

  @override
  void didPush(Route route, Route? previousRoute) => _update();

  @override
  void didRemove(Route route, Route? previousRoute) => _update();
}
