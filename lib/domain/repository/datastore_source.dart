
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/user_data.dart';

import '../model/enum/wireless_type.dart';
import '../model/map/map_data.dart';
import '../model/place_data.dart';
import '../model/token_data.dart';

abstract class DataStoreSource {


  Future<List<PlaceData>> loadPlaceList(WirelessType type);

  Future<void> savePlaceList(WirelessType type, List<PlaceData> placeList);

  Future<void> remove(WirelessType type);

  Future<MapData?> loadMapData(WirelessType type, int idx);

  Future<void> saveMapData(WirelessType type, int idx, MapData mapData);

  Future<void> clearMapData();

  Future<List<MeasureData>> getMeasureList(int idx, WirelessType type);

  Future<void> setMeasureList(int idx, WirelessType type, List<MeasureData> list);

  Future<TokenData?> getTokenData();

  Future<void> setTokenData(TokenData data);

  Future<void> setUserData(UserData userData);
  Future<UserData?> getUserData();

  Future<void> removeTokenData();
  Future<void> removeUserData();
}
