import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/presentation/screen/chart/chart_screen.dart';
import 'package:googlemap/presentation/screen/main/component/drawer_view.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_bloc.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';
import 'package:googlemap/presentation/screen/map/map_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'component/side_menu_view.dart';

class MainScreen extends StatelessWidget {
  static String get routeName => 'main';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<MainBloc, MainState>(
      scaffoldKey: _scaffoldKey,
      create: (context) => MainBloc(
        context,
        MainState(),
      ),
      drawerBuilder: (context, bloc, state) {
        return DrawerView(
          bloc: bloc,
          state: state,
        );
      },
      builder: (context, bloc, state) {
        return DefaultTabController(
          initialIndex: 0,
          length: state.selectedAreaDataSet.length == 1 ? 1 : 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: state.isShowSide ? 400 : 0),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: bloc.pageController,
                  children: [
                    if (state.isShowDialog) const SizedBox(),
                    if (!state.isShowDialog)
                      MapScreen(
                        areaDataSet: state.selectedAreaDataSet,
                        isRemove: state.isRemove,
                        wirelessType: state.type,
                        onReloadArea: () {
                          bloc.add(BlocEvent(MainEvent.onTapRefresh));
                        },
                      ),
                    if (state.selectedAreaDataSet.length == 1)
                      ChartScreen(
                        areaData: state.selectedAreaDataSet.first,
                      ),
                  ],
                ),
              ),
              Positioned(
                left: state.isShowSide ? 400 : 0,
                right: 0,
                bottom: 32,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: bloc.pageController,
                    count: state.selectedAreaDataSet.length == 1 ? 2 : 1,
                    onDotClicked: (index) {
                      bloc.pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                      // bloc.pageController.jumpToPage(index);
                    },
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Color(0xa0000000),
                      dotColor: Color(0x40000000),
                      expansionFactor: 1.5,
                      dotHeight: 24,
                      dotWidth: 32,
                    ),
                  ),
                ),
              ),
              if (state.isShowSide)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  child: SideMenuView(
                    bloc: bloc,
                    state: state,
                    onTapMenu: () async {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                ),
              Positioned(
                top: 0,
                bottom: 0,
                left: state.isShowSide ? 400 : 0,
                child: GestureDetector(
                  onTap: () => bloc.add(BlocEvent(MainEvent.onTapDrawer)),
                  child: SvgPicture.asset(state.isShowSide
                      ? 'assets/icons/ic_drawer_close.svg'
                      : 'assets/icons/ic_drawer_open.svg'),
                ),
              ),
              if (state.isLoading)
                Positioned.fill(
                  child: Container(
                    color: const Color(0x40000000),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // drawer: Drawer(width: 400, child: Text('test...'),),
        );
      },
    );
  }
}
