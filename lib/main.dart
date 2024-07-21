import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'common/const/color.dart';
import 'common/const/network.dart';
import 'common/router/router.dart';
import 'data/database/local_database.dart';
import 'data/datacache/local_datacache.dart';
import 'data/datastore/local_datastore.dart';
import 'data/network/custom_interceptor.dart';
import 'data/network/local_network.dart';
import 'data/repository/database_source_impl.dart';
import 'data/repository/datacache_source_impl.dart';
import 'data/repository/datastore_source_impl.dart';
import 'data/repository/network_source_impl.dart';
import 'data/repository/repository.dart';

void main() {
  runApp(const MyApp());

  // 뒤로 가기 버튼 제어
  // html.window.onPopState.listen((event) {
  //   print(html.window.location.pathname);
  //
  //   if (html.window.location.pathname == '/login' || html.window.location.pathname == '/') {
  //     html.window.history.pushState(null, '', '/login');
  //   }
  // });
}

final rootScaffoldKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      lazy: false,
      create: (context) {
        final databaseSource = DatabaseSourceImpl(
          database: LocalDatabase(),
        );
        final dataStoreSource = DataStoreSourceImpl(
          dataStore: LocalDataStore(),
        );

        final customInterceptor = CustomInterceptor(
          dataStoreSource: dataStoreSource,
          context: context,
        );
        final LocalNetwork localNetwork = LocalNetwork(customInterceptor);
        final networkSource = NetworkSourceImpl(
          localNetwork.dio,
          baseUrl: kNetworkBaseUrl,
        );
        final dataCacheSource = DataCacheSourceImpl(
          dataCache: LocalDataCache(),
        );
        return Repository(
          databaseSource: databaseSource,
          dataStoreSource: dataStoreSource,
          networkSource: networkSource,
          dataCacheSource: dataCacheSource,
        );
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: rootScaffoldKey,
        scrollBehavior: AppScrollBehavior(),
        title: 'iRadar',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          primaryColor: primaryColor,
          fontFamily: 'NotoSansKR',
          tabBarTheme: const TabBarTheme(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoSansKR',
            ),
            labelColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w400,
            ),
            titleMedium: TextStyle(
              color: textColor,
              fontSize: 32,
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w500,
            ),
            titleSmall: TextStyle(
              color: Color(0xff666666),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        routerConfig: routerConfig,
      ),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

/*
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    this.headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,

    TextStyle? titleLarge,
    TextStyle? titleMedium,     // Login
    TextStyle? titleSmall,      // Select Location

    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    this.labelMedium,
    TextStyle? labelSmall,
 */
