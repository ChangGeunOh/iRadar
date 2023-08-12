import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/intf_tt_data.dart';
import 'package:googlemap/domain/model/measure_upload_data.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_event.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_state.dart';

import '../../../../domain/model/intf_data.dart';

class UploadBloc extends BlocBloc<BlocEvent<UploadEvent>, UploadState> {
  UploadBloc(super.context, super.initialState);

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<UploadEvent> event,
    Emitter<UploadState> emit,
  ) async {
    switch (event.type) {
      case UploadEvent.init:
        // final id = repository.get
        break;
      case UploadEvent.onChanged:
        emit(_getState(event.extra, state));
        break;
      case UploadEvent.onTapFile:
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['xls', 'xlsx'],
          type: FileType.custom,
          allowMultiple: false,
        );
        if (result != null) {
          emit(state.copyWith(
            isLoading: true,
            filePickerResult: result,
            fileName: result.files.single.name,
          ));
          add(BlocEvent(UploadEvent.onReadExcel, extra: result));
        }
        break;
      case UploadEvent.onReadExcel:
        var bytes = event.extra.files.single.bytes;
        var excel = Excel.decodeBytes(bytes!);
        var sheet = excel.sheets.values.first;
        final isNoLocation = sheet.maxCols == 20 || sheet.maxCols == 10;
        final isLteOnly = sheet.maxCols == 11 || sheet.maxCols == 13;
        var measureUploadData = _readSheet(sheet, isNoLocation, isLteOnly);
        emit(
          state.copyWith(
            isLoading: false,
            measureUploadData: measureUploadData,
            isNoLocation: isNoLocation,
            isLteOnly: isLteOnly,
          ),
        );
        break;
      case UploadEvent.onLoading:
        emit(state.copyWith(isLoading: event.extra));
        break;
      case UploadEvent.onAddData:
        emit(state.copyWith(isAddData: event.extra));
        break;
      case UploadEvent.onWideArea:
        emit(state.copyWith(isWideArea: event.extra));
        break;
      case UploadEvent.onTapSave:
        emit(state.copyWith(isLoading: true));
        _saveData(state.measureUploadData!, state.group, state.area, state.password);
        break;
    }
  }

  Future<bool> _saveData(
    MeasureUploadData measureUploadData,
    String group,
    String area,
    String password,
  ) async {
    measureUploadData.area = area;
    measureUploadData.password = password;
    measureUploadData.group = group;

    return true;
  }

  // Future<Map<String, dynamic>> test(FilePickerResult result) async {
  //   return compute(readFileInfo, result);
  // }
  //
  // Map<String, dynamic> readFileInfo(FilePickerResult result) {
  //   var fileName = result.files.single.name;
  //   var bytes = result.files.single.bytes;
  //   var excel = Excel.decodeBytes(bytes!);
  //   var sheet = excel.tables.values.first;
  //   final isNoLocation = sheet.maxCols == 20 || sheet.maxCols == 10;
  //   final isLteOnly = sheet.maxCols == 11 || sheet.maxCols == 13;
  //
  //   return {
  //     "fileName": fileName,
  //     "isNoLocation": isNoLocation,
  //     "isLteOnly": isLteOnly
  //   };
  // }

  void _readExcel(
    FilePickerResult result,
  ) {
    var bytes = result.files.single.bytes;
    var excel = Excel.decodeBytes(bytes!);
    excel.tables.forEach((key, table) {
      final isNoLocation = table.maxCols == 20 || table.maxCols == 10;
      final isLteOnly = table.maxCols == 11 || table.maxCols == 13;
      final sheetName = table.sheetName;
      print('$sheetName -------------------->${table.maxCols} :: $isLteOnly');
      table.rows.forEachIndexed((index, row) {
        if (row.first != null && row.first!.value.runtimeType == double) {
          final line = _columnToList(row, isNoLocation, isLteOnly);
        }
      });
    });
  }

  MeasureUploadData? _readSheet(
      Sheet sheet, bool isNoLocation, bool isLteOnly) {
    MeasureUploadData measureUploadData =
        MeasureUploadData();
    sheet.rows.forEachIndexed((index, row) {
      if (row.first != null && row.first!.value.runtimeType == double) {
        final rowData = _columnToList(row, isNoLocation, isLteOnly);
        measureUploadData.intf5GList.addAll(rowData.intf5GList);
        measureUploadData.intfLteList.addAll(rowData.intfLteList);
        measureUploadData.intfTTList.addAll(rowData.intfTTList);
      }
    });
    return measureUploadData;
  }

  MeasureUploadData _columnToList(
    List<Data?> row,
    bool isNoLocation,
    bool isLteOnly,
  ) {
    MeasureUploadData measureUploadData =
        MeasureUploadData();

    var list = row.map((e) => e?.value ?? '').toList();
    if (isNoLocation) {
      list.insertAll(1, [
        '129.150552778',
        '35.1604083333'
      ]); // '129.150552778','35.1604083333'
    }
    if (isLteOnly) {
      list.insertAll(3, ['', '', '']);
      list.insertAll(9, ['', '', '', '', '', '']);
    }

    final regex5g = RegExp(r'(\d+)\(([^)]+)\)\(([^)]+)\)');
    for (var match in regex5g.allMatches(list[3].toString())) {
      final rp = double.parse(match.group(2)!);
      final intf5GData = IntfData(
        idx: 0,
        area: 'area',
        pci: match.group(1)!,
        dt: (list[0] as double).toDateTime(),
        lat: double.parse(list[2].toString()),
        lng: double.parse(list[1].toString()),
        rp: rp,
        rpmw: pow(10, rp / 10.0).toDouble(),
        spci: list[4].toString(),
        srp: list[5], // double
      );
      measureUploadData.intf5GList.add(intf5GData);
    }

    final regexLte = RegExp(r"(\d+)\[(-?\d+\.\d+)\]\[(-?\d+\.\d+)\]");
    for (var match in regexLte.allMatches(list[6].toString())) {
      print("${match.group(1)}, ${match.group(2)}, ${match.group(3)}");
      final rp = double.parse(match.group(2)!);
      final intfData = IntfData(
        idx: 0,
        area: 'area',
        pci: match.group(1)!,
        dt: (list[0] as double).toDateTime(),
        lat: double.parse(list[2].toString()),
        lng: double.parse(list[1].toString()),
        rp: rp,
        rpmw: pow(10, rp / 10.0).toDouble(),
        // $rpmw = pow( 10 , ($spci[1]/10));
        spci: list[7].toString(),
        // int
        srp: list[8], // double
      );
      measureUploadData.intfLteList.add(intfData);
    }

    list[16] = list[16].toString().replaceAll(RegExp(r'[^0-9]'), '');
    list[18] = list[18].toString().replaceAll(RegExp(r'[^0-9]'), '');

    final intfTtData = IntfTtData(
      idx: 0,
      area: 'area',
      lat: _getDouble(list[2]),
      lng: _getDouble(list[1]),
      pci5: list[4].toString(),
      rp5: _getDouble(list[5]),
      pci: list[7].toString(),
      rp: _getDouble(list[8]),
      pw: 'pw',
      cqi5: _getDouble(list[9]),
      ri5: _getDouble(list[10]),
      dlmcs5: _getDouble(list[11]),
      dll5: _getDouble(list[12]),
      dlrb5: _getDouble(list[13]),
      dl5: _getDouble(list[14]),
      ear: _getDouble(list[15]),
      ca: _getDouble(list[16]),
      cqi: _getDouble(list[17]),
      ri: _getDouble(list[18]),
      mcs: _getDouble(list[19]),
      rb: _getDouble(list[20]),
      dl: _getDouble(list[21]),
    );
    measureUploadData.intfTTList.add(intfTtData);

    return measureUploadData;
  }

  double? _getDouble(dynamic value) {
    return value.runtimeType == double
        ? value
        : value.toString().isEmpty
            ? null
            : double.parse(value.toString());
  }

  UploadState _getState(UploadChangeData uploadChangeData, UploadState state) {
    switch (uploadChangeData.type) {
      case UploadChangedType.isNoLocation:
        return state.copyWith(isNoLocation: uploadChangeData.value);
      case UploadChangedType.isLteOnly:
        return state.copyWith(isLteOnly: uploadChangeData.value);
      case UploadChangedType.isWideArea:
        return state.copyWith(isWideArea: uploadChangeData.value);
      case UploadChangedType.isAddData:
        return state.copyWith(isAddData: uploadChangeData.value);
      case UploadChangedType.onDivision:
        return state.copyWith(
            division: uploadChangeData.value, enabledSave: _checkEnableSave());
      case UploadChangedType.onArea:
        return state.copyWith(area: uploadChangeData.value);
      case UploadChangedType.onPassword:
        return state.copyWith(
            password: uploadChangeData.value, enabledSave: _checkEnableSave());
    }
  }

  bool _checkEnableSave() {
    return state.area.length > 5 &&
        state.password.isNotEmpty &&
        state.measureUploadData != null &&
        state.division.isNotEmpty;
  }
}
