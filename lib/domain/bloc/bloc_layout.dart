import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocLayout<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final B Function(BuildContext context) create;
  final Widget Function(BuildContext context, B bloc, S state) builder;

  const BlocLayout({
    required this.create,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: BlocBuilder<B, S>(
        builder: (context, state) {
          final bloc = context.read<B>();
          return builder(context, bloc, state);
        },
      ),
    );
  }

}
