import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_layout.dart';

class BlocScaffold<B extends StateStreamableSource<S>, S>
    extends BlocLayout<B, S> {
  final AppBar? appBar;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final Widget Function(BuildContext context, B bloc, S state)? floatingBuilder;
  final Widget Function(BuildContext context, B bloc, S state)? bottomBuilder;

  const BlocScaffold({
    Key? key,
    required super.create,
    required super.builder,
    this.appBar,
    this.backgroundColor,
    this.bottomSheet,
    this.floatingActionButton,
    this.floatingBuilder,
    this.bottomBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: BlocBuilder<B, S>(
        builder: (context, state) {
          final bloc = context.read<B>();
          return Scaffold(
            appBar: appBar,
            backgroundColor: backgroundColor,
            body: builder(context, bloc, state),
            bottomSheet: bottomBuilder == null
                ? bottomSheet
                : bottomBuilder!(context, bloc, state),
            floatingActionButton: floatingBuilder == null
                ? floatingActionButton
                : floatingBuilder!(context, bloc, state),
          );
        },
      ),
    );
  }
}
