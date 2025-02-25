import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';

part 'notice_data.g.dart';

@JsonSerializable()
class NoticeData {
  final int idx;
  final String title;
  final String? content;
  @JsonKey(
    name: 'created_at',
    fromJson: Convert.dynamicToDateTime,
  )
  final DateTime createdAt;

  NoticeData({
    required this.idx,
    required this.title,
    this.content,
    required this.createdAt,
  });

  NoticeData copyWith({
    int? idx,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return NoticeData(
      idx: idx ?? this.idx,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NoticeData.fromJson(Map<String, dynamic> json) => _$NoticeDataFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeDataToJson(this);
}
