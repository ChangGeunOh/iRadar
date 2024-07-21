import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/presentation/screen/app_info/app_info_screen.dart';
import 'package:googlemap/presentation/screen/base/base_screen.dart';
import 'package:googlemap/presentation/screen/chart/chart_screen.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_bloc.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';
import 'package:googlemap/presentation/screen/map/map_screen.dart';
import 'package:googlemap/presentation/screen/notice/notice_screen.dart';
import 'package:googlemap/presentation/screen/open_source/open_source_screen.dart';
import 'package:googlemap/presentation/screen/password/password_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'component/drawer_list_bottom_item.dart';
import 'component/drawer_list_header.dart';
import 'component/drawer_list_item.dart';
import 'component/main_drawer.dart';

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
        return _buildDrawer(context, bloc, state);
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
                  child: MainDrawer(
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

  Widget _buildDrawer(BuildContext context, MainBloc bloc, MainState state) {
    final height = MediaQuery.of(context).size.height;
    return Drawer(
      width: 350,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 72,
                      backgroundColor: Colors.white,
                      // backgroundImage: AssetImage(
                      //     "assets/images/img_avatar_${Random().nextInt(11).toString().padLeft(2, '0')}.jpg"),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      state.userData?.userName ?? "투덜이TM",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.userData?.getSimpleGroup() ?? "경남액세스운용센터 동진주운용부",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const DrawerListHeader(text: 'UPLOAD BASIC DATA'),
            DrawerListItem(
                title: "업로드 파일 다운로드",
                iconData: Icons.file_copy_outlined,
                onTap: () {
                  _downloadExampleFile();
                }),
            DrawerListItem(
                title: "기지국 정보 업로드",
                iconData: Icons.cell_tower_rounded,
                onTap: () {
                  _showDialog(
                    context,
                    '기지국 정보 업로드',
                    bloc,
                    const BaseScreen(),
                  );
                }),
            const SizedBox(height: 32),
            const DrawerListHeader(text: 'INFORMATION'),
            DrawerListItem(
              title: "공지사항",
              iconData: Icons.notifications_outlined,
              onTap: () async {
                _showDialog(
                  context,
                  '공지사항',
                  bloc,
                  NoticeScreen(),
                );
              },
            ),
            DrawerListItem(
              title: "오픈소스 라이선스",
              iconData: Icons.code_outlined,
              onTap: () {
                _showDialog(
                  context,
                  '오픈소스 라이센스',
                  bloc,
                  OpenSourceScreen(),
                );
              },
            ),
            DrawerListItem(
              title: "App 정보",
              iconData: Icons.info_outline,
              onTap: () {
                _showDialog(
                  context,
                  'App 정보',
                  bloc,
                  const AppInfoScreen(),
                );
              },
            ),
            const SizedBox(height: 32),
            const DrawerListHeader(text: 'AUTHENTICATION'),
            DrawerListItem(
              title: "비밀번호 변경",
              iconData: Icons.lock_outline,
              onTap: () {
                _showDialog(
                  context,
                  '비밀번호 변경',
                  bloc,
                  const PasswordScreen(),
                );
              },
            ),
            const SizedBox(height: 64),
            DrawerListBottomItem(
              title: 'Logout',
              onTap: () {
                bloc.add(BlocEvent(MainEvent.onLogout));
              },
            )
          ],
        ),
      ),
    );
  }

  void _showDialog(
    BuildContext context,
    String title,
    MainBloc bloc,
    Widget child,
  ) async {
    bloc.add(BlocEvent(MainEvent.onShowDialog, extra: true));
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 32.0, right: 32, top: 32, bottom: 16),
              child: SizedBox(
                width: 800,
                height: 798,
                child: child,
              ),
            ),
          );
        });
    bloc.add(BlocEvent(MainEvent.onShowDialog, extra: false));
  }

  Future<void> _downloadExampleFile() async {
      // Load the file as a ByteData
      ByteData data = await rootBundle.load('assets/files/iradar_upload_example_file.zip');
      // Convert ByteData to Uint8List
      final buffer = data.buffer;
      final bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Create a Blob from the Uint8List
      final blob = html.Blob([bytes]);
      // Create an Object URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);
      // Create an AnchorElement
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "iradar_upload_example_file.zip")
        ..click();
      // Revoke the Object URL
      html.Url.revokeObjectUrl(url);
  }

}
