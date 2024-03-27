import 'dart:convert';

import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

const keyFunctionMenuList = "function_menu_list";
const keyEventList = "event_list";
const keyBandBannerData = 'band_banner_data';

class LocalDataStore {
  SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> getSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  Future<dynamic> loadData(String key) async {
    final dataStore = await getSharedPreferences();
    final data = dataStore.getString(key);
    if (data != null) {
      return jsonDecode(data);
    } else {
      return null;
    }
  }

  Future<void> saveData(String key, Object data) async {
    final dataStore = await getSharedPreferences();
    dataStore.setString(key, jsonEncode(data));
  }

  Future<List?> loadListData(String key) async {
    final dataStore = await getSharedPreferences();
    final list = dataStore.getStringList(key);
    print("Load List -----------------------$key");
    print("::$list");
    return list?.map((e) => jsonDecode(e)).toList();
  }

  Future<void> saveListData(String key, List<Object> list) async {
    final dataStore = await getSharedPreferences();
    final encodedList = list.map((e) => jsonEncode(e)).toList();
    // print(encodedList.toString());
    await dataStore.setStringList(key, encodedList);
    // var savedList = dataStore.getStringList(type.name);
    // print("Save List-----------------------${type.name}");
    // print(savedList.toString());
  }

  Future<void> remove(String key) async {
    final dataStore = await getSharedPreferences();
    dataStore.remove(key);
  }
}
