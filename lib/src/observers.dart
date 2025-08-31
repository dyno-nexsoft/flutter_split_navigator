import 'package:flutter/widgets.dart';

class FlutterSplitNavigatorObserver extends NavigatorObserver
    with ChangeNotifier {
  @override
  void notifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      super.notifyListeners();
    });
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final Duration transitionDuration;
    if (route is ModalRoute) {
      transitionDuration = route.reverseTransitionDuration;
    } else {
      transitionDuration = Duration.zero;
    }
    Future.delayed(transitionDuration, notifyListeners);
  }

  @override
  void didPush(Route route, Route? previousRoute) => notifyListeners();

  @override
  void didRemove(Route route, Route? previousRoute) => notifyListeners();
}
