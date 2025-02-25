import '../../../../domain/model/notice/notice_data.dart';

class NoticeState {
  final bool isLoading;
  final int currentPage;
  final int totalPage;
  final List<NoticeData> noticeDataList;
  final NoticeData? noticeData;

  NoticeState({
    this.isLoading = false,
    this.currentPage = 1,
    this.totalPage = 1,
    this.noticeDataList = const [],
    this.noticeData,
  });

  NoticeState copyWith({
    bool? isLoading,
    int? currentPage,
    int? totalPage,
    List<NoticeData>? noticeDataList,
    NoticeData? noticeData,
  }) {
    return NoticeState(
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      noticeDataList: noticeDataList ?? this.noticeDataList,
      noticeData: noticeData ?? this.noticeData,
    );
  }

  NoticeState clearNoticeData() {
    return NoticeState(
      isLoading: isLoading,
      currentPage: currentPage,
      totalPage: totalPage,
      noticeDataList: noticeDataList,
      noticeData: null,
    );
  }
}