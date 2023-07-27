class Convert {
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
}