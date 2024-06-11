import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/response/meta_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';

import '../../domain/model/map/map_data.dart';
import '../../domain/model/place_data.dart';
import '../../domain/repository/datastore_source.dart';
import '../datastore/local_datastore.dart';

const keyIceIconList = 'ice_icon_list';
const keyRecommendMovieList = 'recommend_movie_list';
const keyAdEventData = 'ad_event_data';
const keyAdEventList = 'ad_event_list';

const keyMeasureList = 'measure_list';
const key5GPlaceList = '5g_place_list';
const keyLTEPlaceList = 'lte_place_list';

class DataStoreSourceImpl extends DataStoreSource {
  final LocalDataStore _dataStore;

  DataStoreSourceImpl({
    required LocalDataStore dataStore,
  }) : _dataStore = dataStore;

  @override
  Future<List<PlaceData>> loadPlaceList(WirelessType type) async {
    final key = type == WirelessType.wLte ? keyLTEPlaceList : key5GPlaceList;
    final list = await _dataStore.loadListData(type.name);
    return list?.map((e) => PlaceData.fromJson(e)).toList() ??
        List<PlaceData>.empty();
  }

  @override
  Future<void> savePlaceList(
      WirelessType type, List<PlaceData> placeList) async {
    await _dataStore.saveListData(type.name, placeList);
  }

  @override
  Future<void> remove(WirelessType type) async {
    await _dataStore.remove(type.name);
  }

  @override
  Future<List<MapData>> loadMapDataList(int idx) async {
    final keyMapData = 'map_data_$idx';
    final list = await _dataStore.loadListData(keyMapData);
    return list?.map((e) => MapData.fromJson(e)).toList() ??
        List<MapData>.empty();
  }

  @override
  Future<void> saveMapDataList(int idx, List<MapData> mapDataList) async {
    final keyMapData = 'map_data_$idx';
    await _dataStore.saveListData(keyMapData, mapDataList);
  }

  @override
  Future<List<MeasureData>> getMeasureList(int idx, WirelessType type) async {
    final keyMeasureList = 'measure_list_${idx}_${type.name} ';
    final list = await _dataStore.loadListData(keyMeasureList);
    return list?.map((e) => MeasureData.fromJson(e)).toList() ??
        List<MeasureData>.empty();
  }

  @override
  Future<void> setMeasureList(
      int idx, WirelessType type, List<MeasureData> list) {
    final keyMeasureList = 'measure_list_${idx}_${type.name} ';
    return _dataStore.saveListData(keyMeasureList, list);
  }

}
