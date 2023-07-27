import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/presentation/screen/chart/chart_screen.dart';
import 'package:googlemap/presentation/screen/main/component/side_header.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_bloc.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';
import 'package:googlemap/presentation/screen/map/map_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'component/side_body.dart';

class MainScreen extends StatelessWidget {
  static String get routeName => 'main';

  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocLayout<MainBloc, MainState>(
      create: (context) => MainBloc(
        context,
        MainState(),
      ),
      builder: (context, bloc, state) {
        return DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: state.isShowSide ? 400 : 0),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: bloc.pageController,
                    children: [
                      MapScreen(
                        placeData: state.placeData,
                        isRemove: state.isRemove,
                      ),
                      ChartScreen(
                        placeData: state.placeData,
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
                    child: Container(
                      width: 400,
                      color: Colors.white,
                      child: Column(
                        children: [
                          SideHeader(
                            onSearch: (search) {
                              bloc.add(
                                  BlocEvent(MainEvent.onSearch, extra: search));
                            },
                            onTapWirelessType: (type) => bloc.add(
                              BlocEvent(
                                MainEvent.onTapType,
                                extra: type,
                              ),
                            ),
                            onTapRefresh: ()=> bloc.add(
                              BlocEvent(
                                MainEvent.onTapRefresh,
                              )
                            ),
                          ),
                          if (state.placeList != null)
                            Expanded(
                              child: SideBody(
                                measureList: state.placeList!,
                                onTapItem: (value) {
                                  bloc.add(
                                    BlocEvent(MainEvent.onTapItem,
                                        extra: value),
                                  );
                                },
                                onTapAll: (value) {
                                  print("onTapAll>${value.toString()}");
                                  bloc.add(
                                    BlocEvent(MainEvent.onTapItemAll,
                                        extra: value),
                                  );
                                },
                                onTapRemove: (value) => bloc.add(
                                  BlocEvent(MainEvent.onTapItemRemove,
                                      extra: value),
                                ),
                                onLongPress: (PlaceData value) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          '자료삭제를 하시겠습니까?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                        content: Text(
                                          '"${value.name}" 자료가 삭제 됩니다.',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('취소'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              bloc.add(BlocEvent(
                                                  MainEvent.onDelete,
                                                  extra: value));
                                            },
                                            child: const Text('삭제'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: state.isShowSide ? 400 : 0,
                  child: InkWell(
                    onTap: () => bloc.add(BlocEvent(MainEvent.onTapDrawer)),
                    child: SvgPicture.asset(state.isShowSide
                        ? 'icons/ic_drawer_close.svg'
                        : 'icons/ic_drawer_open.svg'),
                  ),
                ),
                if (state.isLoading)
                  Positioned.fill(
                    child: Container(
                      color: const Color(0x40000000),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
            // drawer: Drawer(width: 400, child: Text('test...'),),
          ),
        );
      },
    );
  }
}
