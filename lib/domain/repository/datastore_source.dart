
import '../model/enum/wireless_type.dart';
import '../model/map/map_data.dart';
import '../model/place_data.dart';

abstract class DataStoreSource {
  Future<List<PlaceData>> loadPlaceList(WirelessType type);

  Future<void> savePlaceList(WirelessType type, List<PlaceData> placeList);

  Future<void> remove(WirelessType type);

  Future<List<MapData>> loadMapDataList(int idx);

  Future<void> saveMapDataList(int idx, List<MapData> mapDataList);
}
