import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../common/const/color.dart';
import '../../../../domain/bloc/bloc_event.dart';
import '../../app_info/app_info_screen.dart';
import '../../base/base_screen.dart';
import '../../base_remove/base_remove_screen.dart';
import '../../notice/notice_screen.dart';
import '../../open_source/open_source_screen.dart';
import '../../password/password_screen.dart';
import '../viewmodel/main_bloc.dart';
import '../viewmodel/main_event.dart';
import '../viewmodel/main_state.dart';
import 'drawer_list_bottom_item.dart';
import 'drawer_list_header.dart';
import 'drawer_list_item.dart';

class DrawerView extends StatelessWidget {
  final MainBloc bloc;
  final MainState state;

  const DrawerView({
    super.key,
    required this.bloc,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
                title: "업로드 샘플 파일 다운로드",
                iconData: Icons.file_copy_outlined,
                onTap: () {
                  _downloadExampleFile("iradar_upload_example_file.zip");
                }),
            DrawerListItem(
              title: "기지국/중계기 정보 업로드",
              iconData: Icons.cell_tower_rounded,
              onTap: () {
                _showDialog(
                  context,
                  '기지국 정보 업로드',
                  bloc,
                  const BaseScreen(),
                );
              },
              description:
                  'Last Update: ${state.baseLastDate.isEmpty ? '자료 없음' : state.baseLastDate}',
            ),
            DrawerListItem(
              title: "기지국/중계기 정보 삭제",
              iconData: Icons.delete_forever_outlined,
              onTap: () {
                _showDialog(
                  context,
                  '기지국/중계기 정보 삭제',
                  bloc,
                  const BaseRemoveScreen(),
                  hasAppBar: true,
                );
              },
            ),
            DrawerListItem(
                title: "기지국/중계기 정보 다운로드",
                iconData: Icons.file_download,
                onTap: () {
                  bloc.add(BlocEvent(
                    MainEvent.onDownloadBaseData,
                  ));
                }),
            DrawerListItem(
              title: "KDM Fav 파일 다운로드",
              iconData: Icons.arrow_circle_down,
              onTap: () {
                _downloadExampleFile('i-Radar Pro_v1.0_Table.kfav');
              },
            ),
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
                  const NoticeScreen(),
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
    Widget child, {
    bool hasAppBar = false,
  }) async {
    bloc.add(BlocEvent(MainEvent.onShowDialog, extra: true));
    final size = MediaQuery.of(context).size;
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: hasAppBar
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(
                      left: 32.0,
                      right: 32,
                      top: 32,
                      bottom: 16,
                    ),
              child: SizedBox(
                width: hasAppBar ? size.width * 0.8 : 800,
                height: hasAppBar
                    ? size.height * 0.8
                    : size.height > 798
                        ? 798
                        : size.height * 0.9,
                child: child,
              ),
            ),
          );
        });
    bloc.add(BlocEvent(MainEvent.onShowDialog, extra: false));
  }

  Future<void> _downloadExampleFile(String fileName) async {
    ByteData data = await rootBundle.load('assets/files/$fileName');
    final buffer = data.buffer;
    final bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
