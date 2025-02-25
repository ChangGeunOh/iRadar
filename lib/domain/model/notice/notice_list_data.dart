import 'package:json_annotation/json_annotation.dart';

import 'notice_data.dart';

part 'notice_list_data.g.dart';

@JsonSerializable()
class NoticeListData {
  final int currentPage;
  final int totalPage;

  final List<NoticeData> dataList;

  NoticeListData({
    this.currentPage = 0,
    this.totalPage = 0,
    required this.dataList,
  });

  factory NoticeListData.fromJson(Map<String, dynamic> json) => _$NoticeListDataFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeListDataToJson(this);
}