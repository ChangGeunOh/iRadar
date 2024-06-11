import 'package:dio/dio.dart' hide Headers;
import 'package:googlemap/common/const/network.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/map/map_base_data.dart';
import 'package:googlemap/domain/model/table_data.dart';
import 'package:googlemap/domain/model/user_data.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/model/chart/measure_data.dart';
import '../../domain/model/excel_response_data.dart';
import '../../domain/model/map/area_data.dart';
import '../../domain/model/map/map_data.dart';
import '../../domain/model/map/merge_data.dart';
import '../../domain/model/place_data.dart';
import '../../domain/model/response/response_data.dart';
import '../../domain/model/token_data.dart';
import '../../domain/model/upload/measure_upload_data.dart';
import '../../domain/repository/network_source.dart';

part 'network_source_impl.g.dart';

@RestApi()
abstract class NetworkSourceImpl extends NetworkSource {
  factory NetworkSourceImpl(Dio dio, {String baseUrl}) = _NetworkSourceImpl;

  @override
  @POST(kPostUserPath)
  @Headers(<String, dynamic>{
    'Content-Type': 'application/json',
  })
  Future<ResponseData<UserData?>> login(
    @Body() String body,
  );

  @override
  @GET('iradar_area_list.php')
  Future<ResponseData<List<PlaceData>>> loadPlaceList(
      {@Query('group') required String group,
      @Query('type') required String type,
      @Query('page') int page = 1,
      @Query('count') int count = 30});

  // @override
  // @GET('pcitt.php')
  // Future<ResponseData<MapData>> loadMapData(@Query('area') String area);

  @override
  @GET('iradar_map_base.php')
  Future<ResponseData<MapBaseData>> loadMapBaseData({
    @Query('group') required String group,
    @Query('idx') required int idx,
  });

  @override
  @GET('iradar_chart_table.php')
  Future<ResponseData<ChartTableData>> loadChartTableData({
    @Query('group') required String group,
    @Query('idx') required int idx,
  });

  @override
  @POST('iradar_excel_data.php')
  @FormUrlEncoded()
  Future<ResponseData<List<ExcelResponseData>>> loadExcelResponseData({
    @Field('group') required String group,
    @Field('type') required String type,
    @Field('idx') required int idx,
    @Field('bts[]') required List<String> bts,
    @Field('cmd') required String cmd,
  });

  @override
  @GET('dtl_pci.php')
  Future<ResponseData<List<TableData>>> loadNpciTableList(
    @Query('a') String link,
    @Query('pci') String npci,
  );

  @override
  @POST(kPostUploadDataPath)
  Future<ResponseData> uploadMeasureData(
    @Body() MeasureUploadData measureUploadData,
  );

  @override
  @GET('api/get_area.php')
  Future<ResponseData<String>> getCountArea({
    @Query('group') required String group,
    @Query('area') required String area,
  });

  @override
  @POST('api/save_merged_data.php')
  @FormUrlEncoded()
  Future<void> saveMergedData({
    @Field('name') required String name,
    @Field('division') required String division,
    @Field('latitude') required double latitude,
    @Field('longitude') required double longitude,
    @Field('password') required String password,
    @Field('type') required String type,
    @Field('merged_idx[]') required List<int> mergedIdxList,
  });

  @override
  @POST(kPostTokenDataPath)
  Future<ResponseData<TokenData?>> postTokenData(@Body() String jsonString);

  @override
  @GET(kGetAreaDataPath)
  Future<ResponseData<List<AreaData>>> getAreaList(String areaCode);

  @override
  @GET(kGetMapDataPath)
  Future<ResponseData<MapData>> getMapDataList({
    @Query('code') required String areaCode,
    @Path('idx') required int idx,
  });

  @override
  @POST(kPostMergeDataPath)
  Future<ResponseData> postMergeData(
    @Body() MergeData mergeData,
  );

  @override
  @GET(kGetMeasureListPath)
  Future<ResponseData<List<MeasureData>>> getMeasureList({
    @Path('idx') required int idx,
    @Path('type') required String type,
  });
}
