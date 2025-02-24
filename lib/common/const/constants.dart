import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const List<String> tabTitles = ['차트', '지도'];
const kWebHeaders = [
  '구분',
  '시도',
  '시군구',
  '행정동/인빌딩/테마 국소명',
  '팀',
  '조',
  '년도',
  '장비구분',
  'ID',
  'NAME',
  '적용내용',
  'Atten',
  'Cell Lock',
  'RU Lock',
  '중계기 Lock',
  'PCI',
  '시나리오 기준',
  'I-Radar\n기준일자',
];

const kSecreteKey = '1649aef524be871f5ba53d5790d4e6aa462fa518aa568bc27bf0e37a546d0aa1';

const initCameraPosition = CameraPosition(
  target: LatLng(35.16861, 129.05091),
  zoom: 14.4746,
);

const kVersionCode = '1.2.0';

const List<Country> countryOptions = <Country>[
  Country(name: 'Africa', size: 30370000),
  Country(name: 'Asia', size: 44579000),
  Country(name: 'Australia', size: 8600000),
  Country(name: 'Bulgaria', size: 110879),
  Country(name: 'Canada', size: 9984670),
  Country(name: 'Denmark', size: 42916),
  Country(name: 'Europe', size: 10180000),
  Country(name: 'India', size: 3287263),
  Country(name: 'North America', size: 24709000),
  Country(name: 'South America', size: 17840000),
];

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "부산", child: Text("부산")),
    const DropdownMenuItem(value: "울산", child: Text("울산")),
    const DropdownMenuItem(value: "경남", child: Text("경남")),
    const DropdownMenuItem(value: "강북", child: Text("강북")),
    const DropdownMenuItem(value: "강원", child: Text("강원")),
    const DropdownMenuItem(value: "강남", child: Text("강남")),
    const DropdownMenuItem(value: "서부", child: Text("서부")),
    const DropdownMenuItem(value: "대구", child: Text("대구")),
    const DropdownMenuItem(value: "경북", child: Text("경북")),
    const DropdownMenuItem(value: "전남", child: Text("전남")),
    const DropdownMenuItem(value: "전북", child: Text("전북")),
    const DropdownMenuItem(value: "충남", child: Text("충남")),
    const DropdownMenuItem(value: "충북", child: Text("충북")),
    const DropdownMenuItem(value: "제주", child: Text("제주")),
  ];
  return menuItems;
}

const divisionList = ['행정동', '인빌딩', '테마'];

class Country {
  const Country({
    required this.name,
    required this.size,
  });

  final String name;
  final int size;

  @override
  String toString() {
    return '$name ($size)';
  }
}


const List<String> headerLteTitle = [
  'PCI',
  'Neighbor\nPCI',
  'Neighbor\nTime',
  'Neighbor\nRSRP\nSUM(dBm)',
  'Interference Index',
  'Serving\nTime',
  'FREQ',
  'CA Type',
  'RSRP',
  'CQI',
  'RI',
  'DL\nMCS',
  'DL\nRB',
  'DL\nMac\nT/P',
  '인근장비'
];

const List<String> header5gTitle = [
  'PCI',
  'Neighbor\nPCI',
  'Neighbor\nTime',
  'Neighbor\nRSRP\nSUM(dBm)',
  'Interference Index',
  'Serving\nTime',
  'SS-\nRSRP',
  'CQI',
  'RI',
  'DL\nMCS',
  'DL\nLayer',
  'DL\nRB',
  'DL\nMac\nT/P',
  '인근장비'
];


// const headerLteWidth = {
//   0: FixedColumnWidth(60),
//   1: IntrinsicColumnWidth(),
//   2: FixedColumnWidth(80),
//   3: FixedColumnWidth(85),
//   4: FixedColumnWidth(80),
//   5: FixedColumnWidth(80),
//   6: FixedColumnWidth(60),
//   7: FixedColumnWidth(60),
//   8: FixedColumnWidth(60),
//   9: FixedColumnWidth(60),
//   10: FixedColumnWidth(60),
//   11: FixedColumnWidth(60),
//   12: FixedColumnWidth(60),
//   13: FixedColumnWidth(60),
//   14: IntrinsicColumnWidth(),
// };

const headerLteWidth = {
  0: FixedColumnWidth(60),
  1: IntrinsicColumnWidth(),
  2: FlexColumnWidth(1.3),
  3: FlexColumnWidth(1.5),
  4: FlexColumnWidth(1.3),
  5: FlexColumnWidth(1.3),
  6: FlexColumnWidth(1.3),
  7: FlexColumnWidth(1),
  8: FlexColumnWidth(1),
  9: FlexColumnWidth(1),
  10: FlexColumnWidth(1),
  11: FlexColumnWidth(1),
  12: FlexColumnWidth(1),
  13: FlexColumnWidth(1.2),
  14: IntrinsicColumnWidth(),
};

// const header5gWidth = {
//   0: FixedColumnWidth(60),
//   1: IntrinsicColumnWidth(),
//   2: FixedColumnWidth(80),
//   3: FixedColumnWidth(85),
//   4: FixedColumnWidth(80),
//   5: FixedColumnWidth(80),
//   6: FixedColumnWidth(60),
//   7: FixedColumnWidth(60),
//   8: FixedColumnWidth(60),
//   9: FixedColumnWidth(60),
//   10: FixedColumnWidth(60),
//   11: FixedColumnWidth(60),
//   12: FixedColumnWidth(60),
//   13: IntrinsicColumnWidth(),
// };

const header5gWidth = {
  0: FixedColumnWidth(60),
  1: IntrinsicColumnWidth(),
  2: FlexColumnWidth(1.3),
  3: FlexColumnWidth(1.5),
  4: FlexColumnWidth(1.3),
  5: FlexColumnWidth(1.3),
  6: FlexColumnWidth(1.3),
  7: FlexColumnWidth(1),
  8: FlexColumnWidth(1),
  9: FlexColumnWidth(1),
  10: FlexColumnWidth(1),
  11: FlexColumnWidth(1),
  12: FlexColumnWidth(1.2),
  13: IntrinsicColumnWidth(),
};