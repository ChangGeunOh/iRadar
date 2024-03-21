import 'package:googlemap/domain/model/response/meta_data.dart';
import 'package:googlemap/domain/model/wireless_type.dart';

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

  @override Future<List<PlaceData>> loadPlaceList(WirelessType type) async {
    final key = type == WirelessType.wLte ? keyLTEPlaceList : key5GPlaceList;
    final list = await _dataStore.loadListData(type.name);
    return list?.map((e) => PlaceData.fromJson(e)).toList() ?? List<PlaceData>.empty();
  }

  @override
  Future<void> savePlaceList(WirelessType type, List<PlaceData> placeList) async {
    await _dataStore.saveListData(type, placeList);
  }

  @override
  Future<void> remove(WirelessType type) async {
    await _dataStore.remove(type);
  }

  // @override
  // Future<void> savePlaceList(List<PlaceData> measureList) async {
  //   await _dataStore.saveListData(keyMeasureList, measureList);
  // }
  //
  // @override
  // Future<List<PlaceData>?> loadPlaceList() async {
  //   final jsonList = await _dataStore.loadListData(keyMeasureList);
  //   return jsonList?.map((e) => PlaceData.fromJson(e)).toList();
  // }
}
