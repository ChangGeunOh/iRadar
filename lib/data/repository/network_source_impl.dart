import 'package:dio/dio.dart' hide Headers;
import 'package:googlemap/common/const/network.dart';
import 'package:googlemap/domain/model/user_data.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/utils/utils.dart';
import '../../domain/model/base/base_data.dart';
import '../../domain/model/chart/measure_data.dart';
import '../../domain/model/map/area_data.dart';
import '../../domain/model/map/best_point_data.dart';
import '../../domain/model/map/map_data.dart';
import '../../domain/model/map/merge_data.dart';
import '../../domain/model/notice/notice_data.dart';
import '../../domain/model/pci/pci_base_data.dart';
import '../../domain/model/response/response_data.dart';
import '../../domain/model/token_data.dart';
import '../../domain/model/upload/measure_upload_data.dart';
import '../../domain/repository/network_source.dart';

part 'network_source_impl.g.dart';

@RestApi()
abstract class NetworkSourceImpl extends NetworkSource {
  factory NetworkSourceImpl(Dio dio) {
    return _NetworkSourceImpl(dio, baseUrl: baseUrl);
  }

  @override
  @GET(kLoginPath)
  Future<ResponseData<TokenData?>> loadLogin(
    @Header("Authorization") String basicAuth,
  );

  // @override
  // @GET('pcitt.php')
  // Future<ResponseData<MapData>> loadMapData(@Query('area') String area);
  @override
  @POST(kUploadDataPath)
  @Headers({'access_token': true})
  Future<ResponseData> uploadMeasureData(
    @Body() MeasureUploadData measureUploadData,
  );

  @override
  @POST(kLoginPath)
  Future<ResponseData<TokenData?>> postTokenData(
    @Body() String jsonString,
  );

  @override
  @GET(kAreaDataPath)
  @Headers({'access_token': true})
  Future<ResponseData<List<AreaData>>> getAreaList(
    String areaCode,
  );

  @override
  @GET(kGetMapDataPath)
  @Headers({'access_token': true})
  Future<ResponseData<MapData>> getMapDataList({
    @Path('type') required String type,
    @Path('idx') required int idx,
  });

  @override
  @POST(kPostMergeDataPath)
  @Headers({'access_token': true})
  Future<ResponseData> postMergeData(
    @Body() MergeData mergeData,
  );

  @override
  @GET(kGetMeasureListPath)
  @Headers({'access_token': true})
  Future<ResponseData<List<MeasureData>>> getMeasureList({
    @Path('idx') required int idx,
    @Path('type') required String type,
    @Query('remove') required bool isRemove,
  });

  @override
  @POST(kBaseDataPath)
  @Headers({'access_token': true})
  Future<ResponseData> uploadBaseData(
    @Body() List<BaseData> uploadData,
  );

  @override
  @POST(kAuthChangePath)
  @Headers({'access_token': true})
  Future<ResponseData> postPassword(
    @Field('old_password') String oldPassword,
    @Field('new_password') String newPassword,
  );

  @override
  @POST(kAreaDataPath)
  @Headers({'access_token': true})
  Future<ResponseData> postAreaData(
    @Body() AreaData data,
  );

  @override
  @Headers({'access_token': true})
  @GET(kUserPath)
  Future<ResponseData<UserData?>> getUserData();

  @override
  @Headers({'access_token': true})
  @GET(kNoticePath)
  Future<ResponseData<List<NoticeData>>> getNoticeList(
    @Query('page') int page,
  );

  @override
  @Headers({'access_token': true})
  @GET(kNoticeDetailPath)
  Future<ResponseData<NoticeData>> getNoticeDetail(@Path('idx') int id);

  @override
  @Headers({'access_token': true})
  @POST(kNoticePath)
  Future<ResponseData<NoticeData>> postNoticeData(NoticeData data);

  @override
  @Headers({'access_token': true})
  @GET(kPciDataPath)
  Future<ResponseData<PciBaseData>> loadPciData({
    @Path('type') required String type,
    @Path('idx') required int idx,
    @Query('spci') required String spci,
  });

  @override
  @Headers({'access_token': false})
  @GET(kNpciDataPath)
  Future<ResponseData<List<MeasureData>>> loadNpciList({
    @Path('type') required String type,
    @Path('idx') required int idx,
    @Query('pci') required String spci,
  });

  @override
  @Headers({'access_token': false})
  @GET(kMapBaseDataPath)
  Future<ResponseData<List<BaseData>>> getBaseList({
    @Query('type') required String type,
    @Query('north_east_longitude') required double northEastLongitude,
    @Query('north_east_latitude') required double northEastLatitude,
    @Query('south_west_longitude') required double southWestLongitude,
    @Query('south_west_latitude') required double southWestLatitude,
  });

  @override
  @Headers({'access_token': false})
  @GET(kSearchAreaDataPath)
  Future<ResponseData<List<AreaData>>> getSearchAreaList();

  @override
  @Headers({'access_token': true})
  @GET(kBaseDataPath)
  Future<ResponseData<List<BaseData>>> getBaseDataList();

  @override
  @Headers({'access_token': true})
  @GET(kBaseLastDatePath)
  Future<ResponseData<String>> getBaseLastDate();

  @override
  @Headers({'access_token': true})
  @GET(kBestPointListPath)
  Future<ResponseData<List<BestPointData>>> getBestPointList({
    @Path('type') required String type,
    @Path('idx') required String idxList,
  });

}
