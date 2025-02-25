import 'package:json_annotation/json_annotation.dart';

part 'page_data.g.dart';

@JsonSerializable()
class PageData{
  final int page;
  final int count;
  final int total;

  PageData({
    required this.page,
    required this.count,
    required this.total,
  });

  factory PageData.fromJson(Map<String, dynamic> json) =>
      _$PageDataFromJson(json);

  Map<String, dynamic> toJson() => _$PageDataToJson(this);
}