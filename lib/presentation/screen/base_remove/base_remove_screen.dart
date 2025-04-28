import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/presentation/screen/base_remove/viewmodel/base_remove_event.dart';
import 'package:googlemap/presentation/screen/main/component/remove_dialog.dart';
import '../../../domain/bloc/bloc_scaffold.dart';
import '../../../domain/model/base/base_data.dart';
import 'viewmodel/base_remove_state.dart';
import 'viewmodel/base_remove_bloc.dart';

class BaseRemoveScreen extends StatelessWidget {
  static String get routeName => 'base-remove';

  const BaseRemoveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<BaseRemoveBloc, BaseRemoveState>(
        create: (context) => BaseRemoveBloc(context, const BaseRemoveState()),
        appBarBuilder: (context, bloc, state) {
          return AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            title: const Text(
              '기지국/중계기 정보 삭제',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              if (state.isSearch)
                SizedBox(
                  width: 250,
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      hintText: '검색어를 입력하세요',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          bloc.add(
                            BlocEvent(
                              BaseRemoveEvent.onClose,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      bloc.add(
                        BlocEvent(
                          BaseRemoveEvent.onSearchText,
                          extra: value,
                        ),
                      );
                    },
                  ),
                ),
              if (!state.isSearch)
                IconButton(
                  onPressed: () {
                    bloc.add(
                      BlocEvent(
                        BaseRemoveEvent.onSearch,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: state.idSet.isEmpty
                    ? null
                    : () {
                        final description =
                            '기지국/중계기 정보 ${state.idSet.length}개를 삭제 하시겠습니까?';
                        _showRemoveDialog(context, description, () {
                          bloc.add(
                            BlocEvent(
                              BaseRemoveEvent.onTapDelete,
                              extra: state.idSet,
                            ),
                          );
                        });
                      },
                icon: Icon(
                  Icons.delete_forever_rounded,
                  color: state.idSet.isEmpty ? Colors.white38 : Colors.white,
                ),
              ),
              const SizedBox(width: 16),
            ],
          );
        },
        builder: (context, bloc, state) {
          return Stack(
            children: [
              PaginatedDataTable2(
                wrapInCard: false,
                headingRowColor: WidgetStateProperty.resolveWith(
                    (state) => Colors.grey[300]),
                headingTextStyle: const TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
                onPageChanged: (value) {
                  print('onPageChanged: $value');
                },
                // onRowsPerPageChanged: (value){
                //   print('onRowsPerPageChanged: $value');
                // },
                columns: [
                  DataColumn2(
                    label: Checkbox(
                      value: state.isSelectAll,
                      checkColor: Colors.white,
                      fillColor: WidgetStateProperty.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.black45;
                          }
                          return Colors.transparent;
                        },
                      ),
                      onChanged: (value) =>
                          bloc.add(BlocEvent(BaseRemoveEvent.onTapSelectAll)),
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    size: ColumnSize.S,
                  ),
                  const DataColumn2(label: Text('ID'), size: ColumnSize.S),
                  const DataColumn2(label: Text('TYPE'), size: ColumnSize.S),
                  const DataColumn2(label: Text('CODE'), size: ColumnSize.M),
                  const DataColumn2(label: Text('NAME'), size: ColumnSize.L),
                  const DataColumn2(label: Text('PCI'), size: ColumnSize.S),
                  const DataColumn2(
                      label: Text('LATITUDE'), size: ColumnSize.M),
                  const DataColumn2(
                      label: Text('LONGITUDE'), size: ColumnSize.M),
                ],
                rowsPerPage: 20,
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 400,
                showCheckboxColumn: false,
                source: _CustomDataTableSource(
                  data: state.filteredBaseDataList,
                  idSet: state.idSet,
                  onSelected: (index, selected) {
                    bloc.add(BlocEvent(
                      BaseRemoveEvent.onTapSelect,
                      extra: {'id': index, 'selected': selected},
                    ));
                  },
                ),
              ),
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
            ],
          );
        });
  }

  void _showRemoveDialog(
    BuildContext context,
    String description,
    Function() onRemove,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return RemoveDialog(
            description: description,
            onRemove: onRemove,
          );
        });
  }
}

class _CustomDataTableSource extends DataTableSource {
  final List<BaseData> data;
  final Set<int> idSet;
  final void Function(int id, bool selected) onSelected;

  _CustomDataTableSource({
    required this.data,
    required this.idSet,
    required this.onSelected,
  });

  @override
  DataRow getRow(int index) {
    final item = data[index];
    final selected = idSet.contains(item.idx);
    return DataRow.byIndex(
      index: index,
      selected: selected,
      onSelectChanged: (bool? value) {
        onSelected(item.idx, value ?? false);
      },
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.blue.shade50;
        }
        return Colors.transparent;
      }),
      cells: [
        DataCell(Checkbox(
          value: selected,
          onChanged: (bool? value) {
            onSelected(item.idx, value ?? false);
          },
          fillColor: WidgetStateProperty.resolveWith((state) {
            if (state.contains(WidgetState.selected)) {
              return primaryColor;
            }
            return Colors.transparent;
          }),
          side: const BorderSide(color: primaryColor, width: 2),
        )),
        DataCell(Text(item.idx.toString())),
        DataCell(Text(item.type)),
        DataCell(Text(item.code)),
        DataCell(Text(item.rnm)),
        DataCell(Text(item.pci.toString())),
        DataCell(Text(item.latitude.toStringAsFixed(6))),
        DataCell(Text(item.longitude.toStringAsFixed(6))),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => idSet.length;
}
