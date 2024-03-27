import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/chart/chart_screen.dart';
import 'package:googlemap/presentation/screen/main/component/side_header.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_bloc.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';
import 'package:googlemap/presentation/screen/map/map_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'component/main_drawer.dart';
import 'component/side_body.dart';

class MainScreen extends StatelessWidget {
  static String get routeName => 'main';

  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<MainBloc, MainState>(
      create: (context) => MainBloc(
        context,
        MainState(),
      ),
      builder: (context, bloc, state) {
        return DefaultTabController(
          initialIndex: 1,
          length: 2,
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
                    ChartScreen(
                      placeData: state.placeData,
                    ),
                    MapScreen(
                      areaDataSet: state.selectedAreaDataSet,
                      isRemove: state.isRemove,
                      wirelessType: state.type,
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
                    count: 2,
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
                  child: MainDrawer(
                    bloc: bloc,
                    state: state,
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
