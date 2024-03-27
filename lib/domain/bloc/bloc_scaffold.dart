import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_layout.dart';

class BlocScaffold<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final B Function(BuildContext context) create;
  final Widget Function(BuildContext context, B bloc, S state) builder;

  final AppBar? appBar;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final Widget Function(BuildContext context, B bloc, S state)? floatingBuilder;
  final Widget Function(BuildContext context, B bloc, S state)? bottomBuilder;
  final AppBar? Function(BuildContext context, B bloc, S state)? appBarBuilder;
  final bool? extendBodyBehindAppBar;

  const BlocScaffold({
    super.key,
    required this.create,
    required this.builder,
    this.appBar,
    this.appBarBuilder,
    this.backgroundColor,
    this.bottomSheet,
    this.floatingActionButton,
    this.floatingBuilder,
    this.bottomBuilder,
    this.extendBodyBehindAppBar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: BlocBuilder<B, S>(
        builder: (context, state) {
          final bloc = context.read<B>();
          return Scaffold(
            extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
            appBar: appBar ??
                (appBarBuilder == null ? null : appBarBuilder!(context, bloc, state)),
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
