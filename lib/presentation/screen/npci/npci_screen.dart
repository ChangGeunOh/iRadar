import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_bloc.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_state.dart';

class NpciScreen extends StatelessWidget {
  const NpciScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocLayout(
      create: (context) => NpciBloc(context, NpciState()),
      builder: (context, bloc, state) {
        return Scaffold(
          body: Center(
            child: Text('NPCI Screen'),
          ),
        );
      },
    );
  }
}
