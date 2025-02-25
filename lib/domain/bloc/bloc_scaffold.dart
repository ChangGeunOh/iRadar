import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class BlocScaffold<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  final B Function(BuildContext context) create;
  final Widget Function(BuildContext context, B bloc, S state) builder;

  final AppBar? appBar;
  final Color? backgroundColor;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final bool? extendBodyBehindAppBar;
  final bool? drawerEnableOpenDragGesture;
  final Widget Function(BuildContext context, B bloc, S state)? floatingBuilder;
  final Widget Function(BuildContext context, B bloc, S state)? bottomBuilder;
  final Widget Function(BuildContext context, B bloc, S state)? drawerBuilder;
  final AppBar? Function(BuildContext context, B bloc, S state)? appBarBuilder;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  BlocScaffold({
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
    this.drawerBuilder,
    this.extendBodyBehindAppBar,
    this.drawerEnableOpenDragGesture,
    this.scaffoldKey
  });


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: BlocBuilder<B, S>(
        builder: (context, state) {
          final bloc = context.read<B>();
          return Scaffold(
            key: scaffoldKey,
            appBar: appBar ??
                (appBarBuilder == null ? null : appBarBuilder!(context, bloc, state)),
            backgroundColor: backgroundColor,
            drawer: drawerBuilder == null ? null : drawerBuilder!(context, bloc, state),
            body: builder(context, bloc, state),
            bottomSheet: bottomBuilder == null
                ? bottomSheet
                : bottomBuilder!(context, bloc, state),
            floatingActionButton: floatingBuilder == null
                ? floatingActionButton
                : floatingBuilder!(context, bloc, state),
            extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
            drawerEnableOpenDragGesture: drawerEnableOpenDragGesture ?? true,
          );
        },
      ),
    );
  }

}

/*
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
 */
