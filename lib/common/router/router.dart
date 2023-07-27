import 'package:go_router/go_router.dart';
import 'package:googlemap/presentation/screen/main/main_screen.dart';

import '../../presentation/screen/login/login_screen.dart';

final routerConfig = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/main',
      name: MainScreen.routeName,
      builder: (_, __) => const MainScreen(),
    ),
  ],
);
