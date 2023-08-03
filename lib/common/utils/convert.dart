class Convert {
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
    return value.runtimeType == int ? value as int : int.parse(value);
  }

  static bool dynamicToBool(dynamic value) {
    var convertedValue = false;
    switch(value.runtimeType) {
      case int:
        convertedValue = (value as int) == 1;
        break;
      case String:
        convertedValue = (value as String) == "1";
        break;
      case bool:
        convertedValue = value as bool;
        break;
    }
    return convertedValue;
  }
}