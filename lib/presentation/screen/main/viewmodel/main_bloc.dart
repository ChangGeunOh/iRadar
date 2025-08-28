import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/area/area_rename_data.dart';
import 'package:googlemap/domain/model/base/base_data.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/presentation/screen/login/login_screen.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';
import 'package:googlemap/presentation/screen/upload/upload_screen.dart';
import 'package:intl/intl.dart';

import '../../../../common/utils/worst_excel_maker.dart';
import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/enum/location_type.dart';

class MainBloc extends BlocBloc<BlocEvent<MainEvent>, MainState> {
  final PageController pageController = PageController(
    initialPage: 0,
  );

  final focusNode = FocusNode();

  MainBloc(super.context, super.initialState) {
    _init();
  }

  void _init() async {
    add(BlocEvent(MainEvent.init));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<MainEvent> event,
    Emitter<MainState> emit,
  ) async {
    switch (event.type) {
      case MainEvent.init:
        final userData = await repository.getUserData();
        final baseLastDate = await repository.getBaseLastDate();
        emit(state.copyWith(
          userData: userData,
          baseLastDate: baseLastDate,
        ));
        await _getAreaList(emit, state);
        break;
      case MainEvent.onTapRefresh:
        await repository.clearCacheData();
        await _getAreaList(emit, state);
        break;
      case MainEvent.onTapType:
        print('onTapType');
        final filteredAreaDataList = state.areaDataList
            .where((element) =>
                element.type == event.extra || element.type == WirelessType.all)
            .toList()
          ..sort((a, b) {
            final divisionA = a.division?.toString() ?? '';
            final divisionB = b.division?.toString() ?? '';
            final divisionComparison = divisionA.compareTo(divisionB);
            if (divisionComparison != 0) return divisionComparison;
            return (b.measuredAt ?? DateTime.fromMillisecondsSinceEpoch(0))
                .compareTo(
                    a.measuredAt ?? DateTime.fromMillisecondsSinceEpoch(0));
          });
        emit(state.copyWith(
          type: event.extra,
          filteredAreaDataList: filteredAreaDataList,
        ));
        break;
      case MainEvent.onDelete:
        final areaData = event.extra as AreaData;
        emit(state.copyWith(isLoading: true));
        final response = await repository.deleteAreaData(areaData);
        emit(state.copyWith(
            message: response.meta.code == 200
                ? '측정 데이터를 삭제 했습니다.'
                : '삭제 중 오류가 발생 했습니다.'));
        if (response.meta.code == 200) {
          await _getAreaList(emit, state);
        }
        emit(state.copyWith(isLoading: false));
        if (context.mounted) {
          context.pop();
        }
        break;
      case MainEvent.onSearch:
        final filteredAreaDataList = state.areaDataList
            .where((element) =>
                element.name.contains(event.extra) &&
                element.type == state.type)
            .toList();
        emit(state.copyWith(
          search: event.extra,
          filteredAreaDataList: filteredAreaDataList,
        ));
        break;
      case MainEvent.onTapDrawer:
        emit(state.copyWith(isShowSide: !state.isShowSide));
        break;
      case MainEvent.onTapItem:
        final AreaData areaData = event.extra;
        Set<AreaData> selectedAreaDataSet;
        if (state.isShiftPressed) {
          selectedAreaDataSet = Set.from(state.selectedAreaDataSet);
          if (selectedAreaDataSet.contains(areaData)) {
            selectedAreaDataSet.remove(areaData);
          } else {
            selectedAreaDataSet.add(areaData);
          }
        } else {
          selectedAreaDataSet = {areaData};
        }
        emit(state.copyWith(
          selectedAreaDataSet: selectedAreaDataSet,
        ));
        break;
      case MainEvent.onTapItemAll:
        emit(state.copyWith(placeData: event.extra, isRemove: false));
        break;
      case MainEvent.onTapItemRemove:
        emit(state.copyWith(placeData: event.extra, isRemove: true));
        break;
      case MainEvent.isLoading:
        emit(state.copyWith(isLoading: event.extra));
        break;
      case MainEvent.onTapMenu:
        break;
      case MainEvent.onTapItemWithShift:
        final AreaData areaData = event.extra;
        var selectedPlace = state.selectedAreaDataSet;
        if (selectedPlace.contains(areaData)) {
          selectedPlace.remove(areaData);
        } else {
          selectedPlace.add(areaData);
        }
        emit(state.copyWith(selectedAreaDataSet: selectedPlace));
        break;
      case MainEvent.onTapUpload:
        final result = await context.pushNamed(UploadScreen.routeName);
        if (result != null && result.runtimeType == bool && result as bool) {
          add(BlocEvent(MainEvent.onTapRefresh));
        }
        break;
      case MainEvent.onTapShiftKey:
        emit(state.copyWith(isShiftPressed: event.extra));
        break;
      case MainEvent.onShowDialog:
        emit(state.copyWith(isShowDialog: event.extra));
        break;
      case MainEvent.onTapNoticePage:
        emit(state.copyWith(currentPage: event.extra + 1));
        break;
      case MainEvent.onLogout:
        await repository.logout();
        if (context.mounted) {
          context.goNamed(LoginScreen.routeName);
        }
        break;
      case MainEvent.onPassword:
        break;
      case MainEvent.onDownloadBaseData:
        emit(state.copyWith(isLoading: true));
        await _downloadExcelBaseData();
        emit(state.copyWith(isLoading: false));
        break;
      case MainEvent.onAreaRename:
        print('MainEvent.onAreaRename');
        final areaRenameData = event.extra as AreaRenameData;
        final response = await repository.postRenameArea(areaRenameData);
        if (response.meta.code == 200) {
          emit(state.copyWith(
            message: '측정 이름을 변경 하였습니다.',
          ));
          await _getAreaList(emit, state);
        } else {
          emit(state.copyWith(
            message: '측정 이름 변경 중 오류가 발생 했습니다.',
          ));
        }
        break;
      case MainEvent.onMessage:
        emit(state.copyWith(message: event.extra));
        break;
      case MainEvent.onTapCacheClear:
        emit(state.copyWith(isLoading: true));
        final areaData = event.extra as AreaData;
        await repository.onClearCache(areaData);
        add(BlocEvent(
          MainEvent.onChangeCache,
          extra: areaData.copyWith(
            isChartCached: false,
            isMapCached: false,
          ),
        ));
        emit(state.copyWith(isLoading: false));
        break;
      case MainEvent.onChangeCache:
        final areaData = event.extra as AreaData;
        final updateAreaDataList = state.areaDataList
            .map(
              (e) => e.idx == areaData.idx && e.type == areaData.type
                  ? areaData.copyWith(
                      isMapCached:
                          e.isMapCached ? e.isMapCached : areaData.isMapCached,
                      isChartCached: e.isChartCached
                          ? e.isChartCached
                          : areaData.isChartCached,
                    )
                  : e,
            )
            .toList();

        final filteredAreaDataList = _getFilteredAreaDataList(
          updateAreaDataList,
          state.search,
          state.type,
        );
        emit(state.copyWith(
          areaDataList: updateAreaDataList,
          filteredAreaDataList: filteredAreaDataList,
        ));
        break;
      case MainEvent.onDownloadExcel:
        final extra = event.extra as Map<String, dynamic>;
        final division = extra['division'] as String;
        final type = extra['type'] as String;
        final count = extra['count'] as int;
        emit(state.copyWith(isLoading: true));
        await _downloadExcelWorstCell(
          state.userData?.userId ?? '',
          division,
          type,
          count,
        );
        emit(state.copyWith(isLoading: false));
        break;
    }
  }

  Future<void> _getAreaList(
    Emitter<MainState> emit,
    MainState state,
  ) async {
    emit(state.copyWith(isLoading: true));
    final responseData = await repository.getAreaList();
    emit(state.copyWith(
      message: responseData.meta.message,
      areaDataList: responseData.data,
      filteredAreaDataList: _getFilteredAreaDataList(
        responseData.data,
        state.search,
        state.type,
      ),
      isLoading: false,
    ));
  }

  List<AreaData> _getFilteredAreaDataList(
    List<AreaData>? areaDataList,
    String search,
    WirelessType type,
  ) {
    if (areaDataList == null || areaDataList.isEmpty) {
      return [];
    }

    return areaDataList.where((element) {
      final matchesName = element.name.contains(search);
      final matchesType =
          element.type == type || element.type == WirelessType.all;
      return matchesName && matchesType;
    }).toList()
      ..sort((a, b) {
        // 1. division 기준으로 정렬 (null 안전)
        final divisionA = a.division?.toString() ?? '';
        final divisionB = b.division?.toString() ?? '';
        final divisionComparison = divisionA.compareTo(divisionB);

        if (divisionComparison != 0) return divisionComparison;

        // 2. measuredAt 기준 내림차순 정렬 (null 안전)
        return (b.measuredAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.measuredAt ?? DateTime.fromMillisecondsSinceEpoch(0));
      });
  }

  Future<void> _downloadExcelBaseData() async {
    final response = await repository.getBaseDataList();
    final List<BaseData> baseDataList = await response.data;
    var excel = Excel.createExcel();
    Sheet sheet = excel.sheets['Sheet1']!;
    sheet.appendRow([
      TextCellValue('No.'),
      TextCellValue('Type'),
      TextCellValue('RU_ID'),
      TextCellValue('Name'),
      TextCellValue('PCI'),
      TextCellValue('Latitude'),
      TextCellValue('Longitude'),
    ]);
    for (var i = 0; i < baseDataList.length; i++) {
      sheet.appendRow([
        IntCellValue(i + 1),
        TextCellValue(baseDataList[i].type),
        TextCellValue(baseDataList[i].code),
        TextCellValue(baseDataList[i].rnm),
        IntCellValue(baseDataList[i].pci),
        DoubleCellValue(baseDataList[i].latitude),
        DoubleCellValue(baseDataList[i].longitude),
      ]);
    }

    Uint8List excelBytes = Uint8List.fromList(excel.save()!);

    String formattedDate = DateFormat('yyyyMMdd').format(DateTime.now());
    String fileName = '($formattedDate) 기지국중계기정보.xlsx';

    final blob = html.Blob([excelBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = fileName
      ..click();
    html.Url.revokeObjectUrl(url); // 메모리 해제
  }

  Future<void> _downloadExcelWorstCell(
    String group,
    String division,
    String type,
    int count,
  ) async {
    final response = await repository.getWorstCellList(division, type, count);
    final locationType =
        LocationType.values.firstWhere((element) => element.name == division);
    final wirelessType =
        WirelessType.values.firstWhere((element) => element.name == type);

    final worstExcelMaker = WorstExcelMaker(
      worstChartDataList: response.data,
      division: locationType,
      type: wirelessType,
    );

    final excel = worstExcelMaker.makeChartExcel();
    final fileName =
        '(${DateTime.now().toDateString(format: "yyyyMMdd")}_$division) $type Worst_Cell 대상 ($group).xlsx';
    excel.save(fileName: fileName);
  }
}
