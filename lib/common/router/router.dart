import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/presentation/screen/main/main_screen.dart';
import 'package:googlemap/presentation/screen/web/web_screen.dart';

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
      routes: [
        GoRoute(
          path: 'web',
          name: WebScreen.routeName,
          builder: (context, state) => WebScreen(
            excelRequestData: state.extra as ExcelRequestData,
          ),
        ),
      ],
    ),
  ],
);
