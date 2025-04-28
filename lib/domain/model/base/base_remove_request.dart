import 'package:json_annotation/json_annotation.dart';


part 'base_remove_request.g.dart';

@JsonSerializable()
class BaseRemoveRequest {
  final List<int> idList;

  BaseRemoveRequest({
    this.idList = const [],
  });

  factory BaseRemoveRequest.fromJson(Map<String, dynamic> json) =>
      _$BaseRemoveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BaseRemoveRequestToJson(this);
}