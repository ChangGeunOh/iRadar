
import 'package:googlemap/domain/model/meta_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/wireless_type.dart';

abstract class DataStoreSource {
  Future<List<PlaceData>> loadPlaceList(WirelessType type);
  Future<void> savePlaceList(WirelessType type, List<PlaceData> placeList);
  Future<void> remove(WirelessType type);
}
