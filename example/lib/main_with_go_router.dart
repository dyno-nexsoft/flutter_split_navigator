import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_split_view/flutter_split_view.dart';
import 'package:go_router/go_router.dart';

class CustomSplitView extends StatefulWidget {
  const CustomSplitView({
    super.key,
    required this.state,
    required this.navigationShell,
    required this.child,
  });

  final GoRouterState state;
  final StatefulNavigationShell navigationShell;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _State();

  static final navigatorObserver = FlutterSplitNavigatorObserver();
  static final chatNavigatorKey = GlobalKey<NavigatorState>();
  static final settingNavigatorKey = GlobalKey<NavigatorState>();
}

class _State extends State<CustomSplitView> with SplitHandler {
  @override
  void initState() {
    super.initState();
    CustomSplitView.navigatorObserver.setState = setState;
  }

  @override
  double get breakpoint => 700.0;

  @override
  bool canPop() => switch (widget.navigationShell.currentIndex) {
    0 => CustomSplitView.chatNavigatorKey.currentState?.canPop() ?? false,
    1 => CustomSplitView.settingNavigatorKey.currentState?.canPop() ?? false,
    int() => false,
  };

  @override
  Widget build(BuildContext context) {
    return super.buildSplit(context);
  }

  @override
  Widget buildPrimary(BuildContext context) {
    return widget.child;
  }

  @override
  Widget buildSecondary(BuildContext context) {
    return widget.navigationShell;
  }
}

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routerConfig: GoRouter(
        initialLocation: '/chat',
        observers: [CustomSplitView.navigatorObserver],
        routes: [
          StatefulShellRoute.indexedStack(
            branches: [
              StatefulShellBranch(
                navigatorKey: CustomSplitView.chatNavigatorKey,
                routes: [
                  GoRoute(
                    path: '/chat',
                    builder: (context, state) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      alignment: Alignment.center,
                      child: const Text('Select a chat'),
                    ),
                    routes: [
                      GoRoute(
                        path: ':chatId',
                        builder: (context, state) => ChatDetailScreen(
                          chatId: state.pathParameters['chatId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: CustomSplitView.settingNavigatorKey,
                routes: [
                  GoRoute(
                    path: '/setting',
                    builder: (context, state) => Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                      alignment: Alignment.center,
                      child: const Text('Select a setting'),
                    ),
                    routes: [
                      GoRoute(
                        path: ':settingId',
                        builder: (context, state) => SettingDetailScreen(
                          settingId: state.pathParameters['settingId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            builder: (context, state, navigationShell) {
              return CustomSplitView(
                state: state,
                navigationShell: navigationShell,
                child: DashboardScreen(
                  state: state,
                  navigationShell: navigationShell,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.state,
    required this.navigationShell,
  });

  final GoRouterState state;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: navigationShell.goBranch,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return IndexedStack(
          index: index,
          children: [
            CustomScrollView(
              slivers: <Widget>[
                const CupertinoSliverNavigationBar.search(
                  largeTitle: Text('Chats'),
                  searchField: CupertinoSearchTextField(),
                ),
                SliverList.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return CupertinoListTile(
                      backgroundColor:
                          state.pathParameters['chatId'] == index.toString()
                          ? CupertinoColors.systemGrey6.resolveFrom(context)
                          : null,
                      title: Text('Chat $index'),
                      subtitle: const Text('Last message preview'),
                      leading: const Icon(
                        CupertinoIcons.profile_circled,
                        size: 32.0,
                      ),
                      onTap: () => GoRouter.of(context).go('/chat/$index'),
                    );
                  },
                ),
              ],
            ),
            CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar.large(
                largeTitle: const Text('Settings'),
              ),
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return CupertinoListTile(
                    backgroundColor:
                        state.pathParameters['settingId'] == index.toString()
                        ? CupertinoColors.systemGrey6.resolveFrom(context)
                        : null,
                    title: Text('Setting $index'),
                    subtitle: const Text('Setting description'),
                    leading: const Icon(CupertinoIcons.settings, size: 32.0),
                    onTap: () => GoRouter.of(context).go('/setting/$index'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  const ChatDetailScreen({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Chat $chatId'),
        previousPageTitle: 'Chats',
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (context, index) {
                return Directionality(
                  textDirection: index % 2 == 0
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: CupertinoListTile(
                    title: Text('Message $index'),
                    subtitle: const Text('This is a message preview'),
                    leading: const Icon(CupertinoIcons.person),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CupertinoTextField(
              placeholder: 'Type a message',
              suffix: Icon(
                CupertinoIcons.arrow_up_circle_fill,
                color: CupertinoTheme.of(context).primaryColor,
                size: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingDetailScreen extends StatelessWidget {
  const SettingDetailScreen({super.key, required this.settingId});

  final String settingId;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Setting $settingId'),
        previousPageTitle: 'Settings',
      ),
      child: Center(child: Text('Details for setting $settingId')),
    );
  }
}
