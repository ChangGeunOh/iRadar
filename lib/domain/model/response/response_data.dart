import 'package:json_annotation/json_annotation.dart';

import 'meta_data.dart';

part 'response_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ResponseData<T> {
  final MetaData meta;
  final T? data;

  ResponseData({
    MetaData? meta,
    this.data,
  }) : meta = meta ?? MetaData();

  factory ResponseData.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$ResponseDataFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$ResponseDataToJson(this, toJsonT);

  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'meta': this.meta.toJson(),
    };
  }

}

