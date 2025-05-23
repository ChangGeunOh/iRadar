import 'package:flutter/material.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/presentation/component/custom_elevated_button.dart';
import 'package:googlemap/presentation/component/iradar_dialog.dart';
import 'package:googlemap/presentation/screen/base/bloc/base_event.dart';

import '../../../common/utils/mixin.dart';
import '../../../common/utils/utils.dart';
import '../../../domain/bloc/bloc_scaffold.dart';
import '../../../domain/model/base/base_data.dart';
import 'bloc/base_bloc.dart';
import 'bloc/base_state.dart';

class BaseScreen extends StatelessWidget with ShowMessageMixin {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<BaseBloc, BaseState>(
        backgroundColor: Colors.white,
        create: (context) => BaseBloc(context, BaseState()),
        builder: (context, bloc, state) {
          if (state.message.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showDialog(
                context: context,
                builder: (context) => IradarDialog(
                  title: state.message,
                ),
              );
              bloc.add(BlocEvent(BaseEvent.onMessage, extra: ''));
            });
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '기지국/중계기 정보 등록',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            '※ CSV 파일(',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Utils.downloadFile("iradar_upload_example_file.zip");
                            },
                            child: const Text(
                              '업로드 샘플 파일 다운로드',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Text(
                            ')로 업로드 해 주세요.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    onTap: () {
                      bloc.add(BlocEvent(BaseEvent.onTapFinder));
                    },
                    text: '파일열기',
                    backgroundColor: Colors.red,
                    enabled: state.baseDataList.isEmpty,
                  ),
                  const SizedBox(width: 8),
                  CustomElevatedButton(
                    onTap: () {
                      bloc.add(BlocEvent(BaseEvent.onTapUpload));
                    },
                    text: '업로드',
                    enabled: state.baseDataList.any((e) => !e.isNotValid()),
                  ),
                  const SizedBox(width: 8),
                  CustomElevatedButton(
                    onTap: () {
                      bloc.add(BlocEvent(BaseEvent.onTapRemove));
                    },
                    text: '자료삭제',
                    backgroundColor: primaryColor,
                    enabled: state.baseDataList.isNotEmpty,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                        child: BaseDataTable(
                      baseDataList: state.baseDataList,
                    )),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        });
  }
}

class BaseDataTable extends StatelessWidget {
  final List<BaseData> baseDataList;

  const BaseDataTable({
    super.key,
    required this.baseDataList,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      columns: _getColumns(),
      source:
          baseDataList.isEmpty ? _EmptyDataSource() : _DataSource(baseDataList),
      headingRowHeight: 42,
      dataRowMinHeight: 32,
      dataRowMaxHeight: 32,
      columnSpacing: 48,
      rowsPerPage: 19,
      controller: ScrollController(),
      showEmptyRows: true,
      showFirstLastButtons: true,
    );
  }

  List<DataColumn> _getColumns() {
    return ['No', 'TYPE', 'ID', 'NAME', 'PCI', 'LATITUDE', 'LONGITUDE']
        .map((e) => DataColumn(label: Text(e)))
        .toList();
  }
}

class _EmptyDataSource extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return const DataRow(cells: [
      DataCell(Text('        ')),
      DataCell(Text('        ')),
      DataCell(Text('                              ')),
      DataCell(Text('                                                     ')),
      DataCell(Text('           ')),
      DataCell(Text('                     ')),
      DataCell(Text('                     ')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => 1;

  @override
  int get selectedRowCount => 0;
}

class _DataSource extends DataTableSource {
  final List<BaseData> baseDataList;

  _DataSource(this.baseDataList);

  @override
  DataRow? getRow(int index) {
    if (index >= baseDataList.length) {
      return null;
    }
    final baseData = baseDataList[index];
    return DataRow(
        color: WidgetStateProperty.resolveWith((states) {
          return baseData.isNotValid() ? Colors.red[200] : Colors.transparent;
        }),
        cells: [
          DataCell(Text(baseData.idx.toString())),
          DataCell(Text(baseData.type)),
          DataCell(Text(baseData.code)),
          DataCell(Text(baseData.rnm)),
          DataCell(Text(baseData.pci.toString())),
          DataCell(Text(baseData.latitude.toStringAsFixed(6))),
          DataCell(Text(baseData.longitude.toStringAsFixed(6))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => baseDataList.length;

  @override
  int get selectedRowCount => 0;
}
