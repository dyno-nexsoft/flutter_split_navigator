import 'package:flutter/widgets.dart';

class FlutterSplitObserver extends NavigatorObserver with ChangeNotifier {
  bool _canPop = false;

  bool canPop() => _canPop;

  @override
  void notifyListeners() {
    if (navigator?.canPop() case final value? when value != _canPop) {
      _canPop = value;
      super.notifyListeners();
    }
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
  void didPush(Route route, Route? previousRoute) {
    Future.delayed(Duration.zero, notifyListeners);
  }
}
