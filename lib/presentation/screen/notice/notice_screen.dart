import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:googlemap/domain/bloc/bloc_event.dart';

import '../../../domain/bloc/bloc_scaffold.dart';
import 'bloc/notice_bloc.dart';
import 'bloc/notice_event.dart';
import 'bloc/notice_state.dart';
import 'widget/notice_detail.dart';
import 'widget/notice_list.dart';

class NoticeScreen extends StatefulWidget {

  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<NoticeBloc, NoticeState>(
      create: (context) => NoticeBloc(context, NoticeState()),
      backgroundColor: Colors.white,
      builder: (context, bloc, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  const Text(
                    '공지사항',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    child: Icon(Icons.add, color: Colors.grey[400], size: 32),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(
              height: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 700,
              child: _child(context, bloc, state),
            ),
          ],
        );
      },
    );
  }

  Widget _child(
    BuildContext context,
    NoticeBloc bloc,
    NoticeState state,
  ) {
    // return Column(
    //   children: [
    //     QuillToolbar.simple(
    //       configurations: QuillSimpleToolbarConfigurations(
    //         controller: _controller,
    //         sharedConfigurations: const QuillSharedConfigurations(
    //           locale: Locale('ko'),
    //
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       child: QuillEditor.basic(
    //         configurations: QuillEditorConfigurations(
    //           controller: _controller,
    //           sharedConfigurations: const QuillSharedConfigurations(
    //             locale: Locale('ko'),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
    if (state.noticeDataList.isEmpty) {
      return const Center(
        child: Text('등록된 공지사항이 없습니다.'),
      );
    }
    if (state.noticeData == null) {
      return NoticeList(
        noticeList: state.noticeDataList,
        currentPage: state.currentPage,
        onTapNoticeData: (noticeData) {
          bloc.add(BlocEvent(
            NoticeEvent.onTapNoticeData,
            extra: noticeData,
          ));
        },
        totalPage: state.totalPage,
        onTapPageNumber: (page) {
          bloc.add(BlocEvent(
            NoticeEvent.onTapPage,
            extra: page,
          ));
        },
      );
    }
    return NoticeDetail(
      noticeData: state.noticeData!,
      onTapClose: () {
        bloc.add(BlocEvent(NoticeEvent.onTapClose));
      },
    );
  }
}
