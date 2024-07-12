import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/data/repository/repository.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/place_table_data.dart';
import 'package:googlemap/presentation/screen/main/main_screen.dart';
import 'package:googlemap/presentation/screen/npci/npci_screen.dart';
import 'package:googlemap/presentation/screen/upload/upload_screen.dart';
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
      path: '/upload2',
      name: 'upload2',
      builder: (_, __) => const UploadScreen(),
    ),
    GoRoute(
      path: '/main',
      name: MainScreen.routeName,
      builder: (_, __) => MainScreen(),
      routes: [
        GoRoute(
          path: 'web',
          name: WebScreen.routeName,
          builder: (context, state) => WebScreen(
            excelRequestData: state.extra as ExcelRequestData,
          ),
        ),
        GoRoute(
          path: 'npci',
          name: NpciScreen.routeName,
          builder: (context, state) => NpciScreen(
            placeTableData: state.extra as PlaceTableData,
          ),
        ),
        GoRoute(
          path: 'upload',
          name: UploadScreen.routeName,
          builder: (_, __) => const UploadScreen(),
        ),
      ],
    ),
  ],
  redirect: (context, state) async {
    final Repository repository = context.read();
    final tokenData =await  repository.getTokenData();
    print('go_router tokenData: $tokenData');
    if (tokenData == null && state.name != LoginScreen.routeName) {
      return '/login';
    }
    return null;
  },
);
