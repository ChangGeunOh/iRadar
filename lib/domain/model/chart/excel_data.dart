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
    String? atten,
    this.cellLock = '',
    this.ruLock = '',
    String? relayLock,
    this.pci = '',
    this.scenario = 'i-Radar',
    this.regDate = '',
    required this.hasColor,
  })  : atten = atten ??
            (type == '5G'
                ? '200'
                : ['RS', 'RB', 'RE'].any((e) => id.startsWith(e))
                    ? ''
                    : '200'),
        relayLock = ['RS', 'RB', 'RE'].any((e) => id.startsWith(e)) ? 'O' : '';
}

