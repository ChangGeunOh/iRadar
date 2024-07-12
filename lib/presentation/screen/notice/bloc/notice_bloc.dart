import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/notice/notice_data.dart';
import 'package:googlemap/presentation/screen/notice/bloc/notice_event.dart';

import '../../../../domain/bloc/bloc_bloc.dart';
import 'notice_state.dart';

class NoticeBloc extends BlocBloc<BlocEvent<NoticeEvent>, NoticeState> {
  NoticeBloc(super.context, super.initialState) {
    init();
  }

  void init() {
    add(BlocEvent(NoticeEvent.init));
  }

  @override
  Future<FutureOr<void>> onBlocEvent(
    BlocEvent<NoticeEvent> event,
    Emitter<NoticeState> emit,
  ) async {
    switch (event.type) {
      case NoticeEvent.init:
        await _getNoticeListData(emit, 1);
        break;
      case NoticeEvent.onTapPage:
        await _getNoticeListData(emit, event.extra);
        break;
      case NoticeEvent.onTapNoticeData:
        final noticeData = event.extra as NoticeData;
        final response = await repository.getNoticeData(noticeData.idx);
        emit(state.copyWith(noticeData: response.data));
        break;
      case NoticeEvent.onTapClose:
        emit(state.clearNoticeData());
        break;
    }
  }

  Future<void> _getNoticeListData(
    Emitter<NoticeState> emit,
    int page,
  ) async {
    final response = await repository.getNoticeList(page);
    int total = response.meta.pageData?.total ?? 0;
    int totalPage = 0;
    if (total > 0) {
      totalPage = (total / 10) .ceil();
    }
    if (response.data != null) {
      emit(state.copyWith(
        currentPage: response.meta.pageData?.page ?? 0,
        totalPage: totalPage,
        noticeDataList: response.data,
      ));
    }
  }
}
