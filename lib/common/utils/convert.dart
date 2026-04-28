import 'package:collection/collection.dart';

import '../../domain/model/enum/wireless_type.dart';

class Convert {
  static WirelessType dynamicToWirelessType(dynamic value) {
    final type = WirelessType.values.firstWhereOrNull((e) => e.name.toLowerCase() == value.toString().toLowerCase());
    return type ?? WirelessType.undefined;
  }

  static dynamic wirelessTypeToDynamic(WirelessType? value) {
    return value?.name ?? 'none';
  }

  static String dynamicToString(dynamic value) {
    return value.toString();
  }


  static dynamic boolToDynamic(bool value) {
    return value;
  }

  static String listToString(List<String> values) {
   return values.join("|");
  }
  static List<String> stringToList(String value) {
   return value.split('|').toList();
  }

  static bool stringToBool(String value) {
    return value == "1" || value.toUpperCase() == "TRUE";
  }

  static String boolToString(bool value) {
    return value ? "1" : "";
  }

  static int stringToInt(String value) {
    return int.parse(value);
  }

  static String intToString(int value) {
    return value.toString();
  }

  static double stringToDouble(String value) {
    return double.parse(value);
  }

  static String doubleToString(double value) {
    return value.toString();
  }

  static int dynamicToInt(dynamic value) {
    switch (value) {
      case int _:
        return value;
      case String _:
        final intValue = int.tryParse(value);
        return intValue ?? -1;
      default:
        return -1;
    }
  }
  static double dynamicToDouble(dynamic value) {
    switch (value) {
      case double _:
        return value;
      case int _:
        return value.toDouble();
      case String _:
        final doubleValue = double.tryParse(value);
        return doubleValue ?? -1.0;
      default:
        return -1.0;
    }
  }

  static bool dynamicToBool(dynamic value) {
    var convertedValue = false;
    switch (value) {
      case int _:
        convertedValue = value == 1;
        break;
      case String _:
        convertedValue = value == "1";
        break;
      case bool _:
        convertedValue = value;
        break;
    }
    return convertedValue;
  }

  static DateTime dynamicToDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    switch (value) {
      case DateTime _:
        return value;
      case int _:
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      case String _:
        return DateTime.parse(value);
      default:
        return DateTime.now();
    }
  }

  static dynamic dateTimeToDynamic(DateTime? value) {
    return value?.toIso8601String();
  }

}