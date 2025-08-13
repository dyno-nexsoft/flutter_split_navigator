import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_split_view/flutter_split_view.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routerConfig: GoRouter(
        routes: [
          ShellRoute(
            navigatorKey: navigatorKey,
            observers: [observer],
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const MyScreen(title: 'Home'),
              ),
              GoRoute(
                path: '/profile',
                builder: (context, state) => const MyScreen(title: 'Profile'),
              ),
            ],
            builder: (context, state, navigationShell) {
              return MySplitView(
                state: state,
                secondary: navigationShell,
                primary: const MyScreen(title: 'Example split view'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: [
          ListTile(
            onTap: () => GoRouter.of(context).go('/'),
            title: const Text('Go to Home'),
          ),
          ListTile(
            onTap: () => GoRouter.of(context).push('/'),
            title: const Text('Push to Home'),
          ),
          ListTile(
            onTap: () => GoRouter.of(context).push('/profile'),
            title: const Text('Push to Profile'),
          ),
        ],
      ),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();
final observer = FlutterSplitNavigatorObserver();

class MySplitView extends StatefulWidget {
  const MySplitView({
    super.key,
    required this.state,
    required this.primary,
    required this.secondary,
  });

  final GoRouterState state;
  final Widget primary, secondary;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MySplitView> with SplitHandler {
  @override
  void initState() {
    super.initState();
    observer.setState = setState;
  }

  @override
  double get breakpoint => 700.0;

  @override
  bool canPop() => navigatorKey.currentState?.canPop() ?? false;

  @override
  Widget build(BuildContext context) {
    return super.buildBody(context);
  }

  @override
  Widget buildPrimary(BuildContext context) {
    return widget.primary;
  }

  @override
  Widget buildSecondary(BuildContext context) {
    return widget.secondary;
  }
}
