import 'dart:convert';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../data/repository/repository.dart';
import '../../domain/model/enum/wireless_type.dart';
import '../../domain/model/map/area_data.dart';
import '../../domain/model/map/map_base_data.dart';
import '../../domain/model/map/map_measured_data.dart';
import '../const/network.dart';
import 'dart:html' as html;

// 문자열 중에서 숫자만 추출
class Utils {
  String getNumbersFromString(String inputString) {
    RegExp regex = RegExp(r'\d+(\.\d+)?');
    Iterable<Match> matches = regex.allMatches(inputString);
    String extractedNumbers = '';

    for (Match match in matches) {
      extractedNumbers += match.group(0)!;
    }

    return extractedNumbers;
  }

// 문자열 알짜와 오늘 날짜 차이
  int calculateDaysDifference(String dateString) {
    DateTime selectedDate = DateFormat('yyyy.MM.dd').parse(dateString);
    DateTime currentDate = DateTime.now();
    Duration difference = selectedDate.difference(currentDate);
    int daysDifference = difference.inDays;

    return daysDifference;
  }

  static String hashPassword(String password, String secretKey) {
    var key = utf8.encode(secretKey);
    var bytes = utf8.encode(password);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  static String get baseUrl {
    const isDebug = bool.fromEnvironment("dart.vm.product") == false;
    return isDebug ? kNetworkDebugBaseUrl : kNetworkReleaseBaseUrl;
  }

  static Future<void> downloadFile(String fileName) async {
    ByteData data = await rootBundle.load('assets/files/$fileName');
    final buffer = data.buffer;
    final bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static Future<Set<Marker>> getMeasureMarkerByAreaSet({
    required Set<AreaData> areaDataSet,
    required WirelessType type,
    required bool isSpeed,
    required bool isLabel,
    required Repository repository,
  }) async {
    Set<Marker> measureMarkerSet = {};
    for (var areaData in areaDataSet) {
      final responseData = await repository.getMapData(type, areaData.idx);
      if (responseData.data != null) {
        final data = responseData.data!;
        final measureMarkers = await getMeasureMarkersCommon(
          type: type,
          idx: areaData.idx,
          measureList: data.measuredData,
          isSpeed: isSpeed,
          isLabel: isLabel,
          repository: repository,
        );
        measureMarkerSet.addAll(measureMarkers);
      }
    }

    return measureMarkerSet;
  }

  static String getMeasureImagePathRSRP(double rsrp) {
    final List<double> rsrpThresholds = [-120, -110, -100, -90, -80, -70];
    final List<int> pinIndices = [0, 1, 2, 4, 7, 8, 10];
    final filenames = List.generate(
      12,
      (index) => 'assets/icons/pin$index.jpg',
      growable: false,
    );

    final index = rsrpThresholds.indexWhere((threshold) => rsrp <= threshold);
    final pinIndex = (index != -1) ? pinIndices[index] : pinIndices.last;
    return filenames[pinIndex];
  }

  static String getMeasureImagePathSpeed(double speed, WirelessType type) {
    final List<double> speedLteThresholds = [300, 200, 100, 50, 0];
    final List<double> speed5GThresholds = [850, 650, 450, 250, 150, 0];

    final thresholds =
        type == WirelessType.w5G ? speed5GThresholds : speedLteThresholds;

    final index = thresholds.indexWhere((threshold) => speed >= threshold);
    final safeIndex = index >= 0 ? index : thresholds.length - 1;
    return 'assets/icons/ic_pin_circle_$safeIndex.png';
  }

  static Future<BitmapDescriptor> makeMeasureMarker({
    required String pci,
    required String iconPath,
    required bool isLabel,
    required bool isSpeed,
    required BitmapDescriptor? Function({
    required String pci,
    required String iconPath,
    required bool isLabel,
    required bool isSpeed,
    }) getCache,
    required void Function({
    required String pci,
    required String iconPath,
    required BitmapDescriptor bitmapDescriptor,
    required bool isLabel,
    required bool isSpeed,
    }) setCache,
  }) async {
    final cached = getCache(
      pci: pci,
      iconPath: iconPath,
      isLabel: isLabel,
      isSpeed: isSpeed,
    );
    if (cached != null) return cached;

    const canvasSize = Size(30, 30); // 텍스트 공간 확보 위해 세로 약간 키움

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // 이미지 로딩
    final ByteData data = await rootBundle.load(iconPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 10, // ✅ 요청한대로 10으로 설정
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    final paint = ui.Paint();

    // 이미지 그리기
    final double imageOffsetY = isLabel ? 0 : (canvasSize.height - frameInfo.image.height) / 2 - 10;
    canvas.drawImage(
      frameInfo.image,
      Offset((canvasSize.width - frameInfo.image.width) / 2, imageOffsetY),
      paint,
    );

    // 텍스트 그리기
    if (isLabel) {
      var textStyle = ui.TextStyle(
        color: const ui.Color(0xFF000000),
        fontSize: 12,
        fontWeight: ui.FontWeight.w500,
      );
      final paragraphStyle = ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 12,
      );
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(pci);

      final paragraph = paragraphBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize.width));

      canvas.drawParagraph(paragraph, Offset(0, canvasSize.height - 13));
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(canvasSize.width.toInt(), canvasSize.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final markerBytes = byteData!.buffer.asUint8List();

    final bitmap = BitmapDescriptor.fromBytes(markerBytes);

    setCache(
      pci: pci,
      iconPath: iconPath,
      bitmapDescriptor: bitmap,
      isLabel: isLabel,
      isSpeed: isSpeed,
    );

    return bitmap;
  }

  static Future<Set<Marker>> makeMeasureMarkerByAreaSet({
    required Set<AreaData> areaDataSet,
    required WirelessType type,
    required bool isSpeed,
    required bool isLabel,
    required Repository repository,
  }) async {
    Set<Marker> measureMarkerSet = {};
    for (var areaData in areaDataSet) {
      final responseData = await repository.getMapData(type, areaData.idx);
      if (responseData.data != null) {
        final data = responseData.data!;
        final measureMarkers = await getMeasureMarkersCommon(
          type: type,
          idx: areaData.idx,
          measureList: data.measuredData,
          isSpeed: isSpeed,
          isLabel: isLabel,
          repository: repository,
        );
        measureMarkerSet.addAll(measureMarkers);
      }
    }

    return measureMarkerSet;
  }

  static Future<Set<Marker>> getMeasureMarkersCommon({
    required WirelessType type,
    required int idx,
    required List<MapMeasuredData> measureList,
    required bool isSpeed,
    required bool isLabel,
    required Repository repository,
  }) async {
    final markers = isSpeed
        ? repository.getMeasureMarkersSpeed(idx, type)
        : repository.getMeasureMarkers(idx, type);

    if (markers != null) return markers;

    final Set<Marker> markerSet = {};
    for (var measure in measureList) {
      final iconPath = isSpeed
          ? getMeasureImagePathSpeed(
              measure.dltp,
              type,
            )
          : getMeasureImagePathRSRP(measure.rsrp);

      final icon = await makeMeasureMarker(
        pci: measure.pci.toString(),
        iconPath: iconPath,
        isLabel: isLabel,
        isSpeed: isSpeed,
        getCache: repository.getCustomMeasureMarker,
        setCache: repository.setCustomMeasureMarker,
      );

      markerSet.add(
        Marker(
          markerId: MarkerId('M${measure.idx}'),
          icon: icon,
          position: LatLng(measure.latitude, measure.longitude),
          infoWindow: InfoWindow(
            title:
                "${measure.pci}/${measure.rsrp}/${measure.dltp.toStringAsFixed(1)}M",
            snippet: measure.getCells(),
          ),
        ),
      );
    }

    return markerSet;
  }

  static Future<Set<Marker>> getBaseMarkers({
    required int idx,
    required List<MapBaseData> mapBaseDataSet,
    required WirelessType type,
    required bool isLabelEnabled,
    required Repository repository,
  }) async {
    Set<Marker>? markers = isLabelEnabled
        ? repository.getBaseMarkers(idx, type)
        : repository.getNoLabelBaseMarkers(idx, type);

    if (markers != null) {
      return markers;
    }

    markers = {};
    Map<double, MapBaseData> latBaseMap = {};

    if (isLabelEnabled) {
      for (var mapBaseData in mapBaseDataSet) {
        if (latBaseMap.containsKey(mapBaseData.latitude)) {
          var baseData = latBaseMap[mapBaseData.latitude];
          baseData = baseData!.copyWith(
              name:
                  '${baseData.name}\n(${mapBaseData.pci}) ${mapBaseData.name}');
          latBaseMap[mapBaseData.latitude] = baseData;
        } else {
          latBaseMap[mapBaseData.latitude] = mapBaseData.copyWith(
              name: "(${mapBaseData.pci}) ${mapBaseData.name}");
        }
      }
    } else {
      for (var mapBaseData in mapBaseDataSet) {
        latBaseMap[mapBaseData.latitude] = mapBaseData;
      }
    }

    for (var mapBaseData in latBaseMap.values) {
      var markerIcon = await createCustomMarker(
        mapBaseData.iconPath(type),
        mapBaseData.name,
        isCaption: isLabelEnabled,
      );

      markers.add(Marker(
        markerId: MarkerId('BASE${mapBaseData.code}'),
        position: LatLng(mapBaseData.latitude, mapBaseData.longitude),
        icon: markerIcon,
        anchor: const Offset(0.5, 0),
        infoWindow: InfoWindow(
          title: "${mapBaseData.code} (${mapBaseData.pci})",
          snippet: mapBaseData.name,
        ),
      ));
    }

    // 중계기기 RS/RB/RE 앞 2자리로 주로 구분됨

    if (isLabelEnabled) {
      repository.setBaseMarkers(idx, markers, type);
    } else {
      repository.setNoLabelBaseMarkers(idx, markers, type);
    }

    return markers;
  }

  static Future<BitmapDescriptor> createCustomMarker(
    String? markerPath,
    String caption, {
    bool isCaption = true,
  }) async {
    final lines = caption.split('\n').length;
    const int width = 400;
    const int imageSize = 14;
    final int height = 24 * (lines + 1) + imageSize; // ✅ 이미지 높이 추가

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint = Paint()..color = Colors.transparent;
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
      paint,
    );

    // ✅ 텍스트 추가 (이미지 위)
    final TextPainter textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: caption,
      style: TextStyle(
        fontSize: 14,
        color: isCaption ? Colors.black : Colors.transparent,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSansKR',
      ),
    );
    textPainter.layout();

    // ✅ 텍스트를 중앙 상단에 배치
    final double textOffsetX = (width - textPainter.width) / 2;
    const double textOffsetY = 0; // 텍스트는 상단에 배치
    textPainter.paint(canvas, Offset(textOffsetX, textOffsetY));

    if (markerPath != null) {
      final ByteData data = await rootBundle.load(markerPath);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      // ✅ 이미지를 하단 중앙에 배치
      const double imageOffsetX = (width - imageSize) / 2;
      final double imageOffsetY =
          (height - image.height) as double; // ✅ 텍스트 아래에 위치
      canvas.drawImage(
        image,
        Offset(imageOffsetX, imageOffsetY),
        Paint(),
      );
    }

    // ✅ 이미지와 텍스트가 그려진 캔버스를 BitmapDescriptor로 변환
    final ui.Image markerImage =
        await pictureRecorder.endRecording().toImage(width, height);
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(uint8List);
  }
}
