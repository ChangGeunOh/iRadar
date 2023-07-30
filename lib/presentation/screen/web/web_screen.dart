import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_bloc.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_state.dart';

import '../../../domain/model/place_data.dart';

class WebScreen extends StatelessWidget {
  static String get routeName => 'web_screen';

  final PlaceData placeData;

  const WebScreen({
    required this.placeData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocLayout<WebBloc, WebState>(
      create: (context) => WebBloc(context, WebState()),
      builder: (context, bloc, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(placeData.name),
          ),
          body: Center(
            child: Text('WebScreen'),
          ),
        );
      },
    );
  }
}
