import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';

import 'viewmodel/web_bloc.dart';
import 'viewmodel/web_event.dart';
import 'viewmodel/web_state.dart';

class WebScreen extends StatelessWidget {
  static String get routeName => 'web_screen';

  final ExcelRequestData excelRequestData;

  const WebScreen({
    required this.excelRequestData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocLayout<WebBloc, WebState>(
      create: (context) => WebBloc(context, WebState()),
      builder: (context, bloc, state) {
        if (state.excelRequestData == null) {
          bloc.add(
            BlocEvent(
              WebEvent.onInit,
              extra: excelRequestData,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(excelRequestData.placeData.name),
          ),
          body: Center(
            child: Text('WebScreen'),
          ),
        );
      },
    );
  }
}
