import 'package:flutter/widgets.dart';

class FlutterSplitView extends Navigator {
  const FlutterSplitView({
    super.key,
    super.pages,
    super.initialRoute,
    super.onGenerateInitialRoutes,
    super.onGenerateRoute,
    super.restorationScopeId,
    super.observers,
    super.onDidRemovePage,
  });

  @override
  NavigatorState createState() => FlutterSplitViewState();

  static FlutterSplitViewState of(BuildContext context) {
    FlutterSplitViewState? navigator;
    if (context is StatefulElement && context.state is FlutterSplitViewState) {
      navigator = context.state as FlutterSplitViewState;
    }
    navigator ??= context.findAncestorStateOfType<FlutterSplitViewState>();

    assert(() {
      if (navigator == null) {
        throw FlutterError(
          'FlutterSplitView operation requested with a context that does not include a FlutterSplitView.\n'
          'The context used to push or pop routes from the FlutterSplitView must be that of a '
          'widget that is a descendant of a FlutterSplitView widget.',
        );
      }
      return true;
    }());
    return navigator!;
  }
}

class FlutterSplitViewState extends NavigatorState {
  final _secondaryKey = GlobalKey<NavigatorState>();

  NavigatorState get secondaryNavigator => _secondaryKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        super.build(context),
        Navigator(
          key: _secondaryKey,
          pages: widget.pages,
          initialRoute: widget.initialRoute,
          onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
          onGenerateRoute: widget.onGenerateRoute,
          observers: widget.observers,
        ),
      ],
    );
  }
}
