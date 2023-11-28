import 'package:dio/dio.dart' hide Headers;
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map_base_data.dart';
import 'package:googlemap/domain/model/measure_upload_data.dart';
import 'package:googlemap/domain/model/response_data.dart';
import 'package:googlemap/domain/model/table_data.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/model/excel_response_data.dart';
import '../../domain/model/place_data.dart';
import '../../domain/repository/network_source.dart';

part 'network_source_impl.g.dart';

@RestApi()
abstract class NetworkSourceImpl extends NetworkSource {
  factory NetworkSourceImpl(Dio dio, {String baseUrl}) = _NetworkSourceImpl;

  @override
  @GET('path')
  Future<List<String>> loadBanners();

  @override
  @GET('#none')
  Future<dynamic> loadMovieChart();

  @override
  @POST('login.php')
  @FormUrlEncoded()
  Future<ResponseData<LoginData>> login({
    @Field('area') required String area,
    @Field('userid') required String password,
  });

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
  @POST('bts_ex.php')
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
  @POST('api/upload.php')
  Future<ResponseData<String>> uploadMeasureData(
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
}
