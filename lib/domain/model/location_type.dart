enum LocationType {
  inBuilding('인빌딩'),
  adminBuilding('행정동'),
  theme('테마'),
  undefined('undefined');

  final String name;

  const LocationType(this.name);

  factory LocationType.getByName(String name) {
    return LocationType.values.firstWhere(
          (element) => element.name == name,
      orElse: () => LocationType.undefined,
    );
  }
}
