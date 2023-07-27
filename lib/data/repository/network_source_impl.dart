import 'package:dio/dio.dart';
import 'package:googlemap/domain/model/area_data.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map_data.dart';
import 'package:googlemap/domain/model/measure_data.dart';
import 'package:googlemap/domain/model/response_data.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/model/base_data.dart';
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
  Future<ResponseData<LoginData>> login(
      {@Field('area') required String area,
      @Field('userid') required String password});

  @override
  @GET('5gtl.php')
  Future<ResponseData<List<AreaData>>> loadPlaceList(
      @Query('type') String type);

  @override
  @GET('pcitt.php')
  Future<ResponseData<MapData>> loadMapData(@Query('area') String area);

  @override
  @GET('dtl.php')
  Future<ResponseData<ChartTableData>> loadChartTableData(@Query('area') String area);
}
