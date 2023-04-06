import 'package:go_router/go_router.dart';
import 'package:mapmo/features/authentication/login_screen.dart';
import 'package:mapmo/features/common/views/main_navigation_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: LoginScreen.routeURL,
      name: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/:tab(home|listview)",
      name: MainNavigationScreen.routeName,
      builder: (context, state) {
        final tab = state.params["tab"]!;
        return MainNavigationScreen(tab: tab);
      },
    ),
    /* GoRoute(
      path: PlaceDetailScreen.routeName,
      builder: (context, state) => const PlaceDetailScreen(),
    ), */
  ],
);
