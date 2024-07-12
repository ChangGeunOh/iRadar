class ExcelData {
  final String division;
  final String sido;
  final String sigungu;
  final String area;
  final String type;
  final String team;
  final String jo;
  final String year;
  final String id;
  final String rnm;
  final String memo;
  final String atten;
  final String cellLock;
  final String ruLock;
  final String relayLock;
  final String pci;
  final String scenario;
  final String regDate;
  final bool hasColor;

  ExcelData({
    this.division = '',
    this.sido = '',
    this.sigungu = '',
    required this.area,
    this.team = '',
    this.jo = '',
    required this.year,
    required this.type,
    this.id = '',
    this.rnm = '',
    this.memo = '',
    this.atten = '200',
    this.cellLock = '',
    this.ruLock = '',
    this.relayLock = '',
    this.pci = '',
    this.scenario = 'i-Radar',
    this.regDate = '',
    required this.hasColor,
  });
}