import 'package:googlemap/domain/model/base/base_data.dart';
import 'package:googlemap/domain/model/map/merge_data.dart';
import 'package:googlemap/domain/model/pci/pci_base_data.dart';
import 'package:googlemap/domain/model/response/response_data.dart';
import 'package:googlemap/domain/model/token_data.dart';
import 'package:googlemap/domain/model/user_data.dart';

import '../model/chart/measure_data.dart';
import '../model/map/area_data.dart';
import '../model/map/map_data.dart';
import '../model/notice/notice_data.dart';
import '../model/upload/measure_upload_data.dart';

abstract class NetworkSource {

  Future<ResponseData<TokenData?>> loadLogin(
    String basicAuth,
  );

  Future<ResponseData> uploadMeasureData(
    MeasureUploadData measureUploadData,
  );


  Future<ResponseData<TokenData?>> postTokenData(String jsonString);

  Future<ResponseData<List<AreaData>>> getAreaList(String areaCode);

  Future<ResponseData<MapData>> getMapDataList({
    required String areaCode,
    required int idx,
  });

  Future<ResponseData> postMergeData(MergeData mergeData);

  Future<ResponseData<List<MeasureData>>> getMeasureList(
      {required int idx, required String type});

  Future<ResponseData> uploadBaseData(List<BaseData> uploadData);

  Future<ResponseData> postPassword(String oldPassword, String newPassword);

  Future<ResponseData> postAreaData(AreaData data);

  Future<ResponseData<UserData?>> getUserData();

  Future<ResponseData<List<NoticeData>>> getNoticeList(int page);

  Future<ResponseData<NoticeData>> getNoticeDetail(int id);

  Future<ResponseData<NoticeData>> postNoticeData(NoticeData data);

  Future<ResponseData<PciBaseData>> loadPciData({
    required String type,
    required int idx,
    required String spci,
  });

  Future<ResponseData<List<MeasureData>>> loadNpciList({
    required String type,
    required int idx,
    required String spci,
  });
}
