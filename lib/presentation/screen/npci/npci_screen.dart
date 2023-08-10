import 'package:flutter/material.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/domain/model/place_table_data.dart';
import 'package:googlemap/domain/model/table_data.dart';
import 'package:googlemap/presentation/screen/npci/component/chart_layout.dart';
import 'package:googlemap/presentation/screen/npci/component/table_layout.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_bloc.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_event.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_state.dart';

class NpciScreen extends StatelessWidget {
  static String get routeName => 'npci_screen';

  final PlaceTableData placeTableData;

  const NpciScreen({
    required this.placeTableData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocLayout<NpciBloc, NpciState>(
      create: (context) => NpciBloc(context, NpciState()),
      builder: (context, bloc, state) {
        if (state.tableList == null) {
          bloc.add(BlocEvent(NpciEvent.init, extra: placeTableData));
        }
        final tableList = state.tableList ?? List.empty();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(placeTableData.placeData.name),
            actions: [
              IconButton(
                onPressed: () => bloc.add(BlocEvent(NpciEvent.onTapWeb)),
                icon: const Icon(
                  Icons.web,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                onPressed: ()=> bloc.add(BlocEvent(NpciEvent.onTapExcel)),
                icon: const Icon(
                  Icons.file_download,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          body: ListView(
            children: [
              const SizedBox(height: 24),
              if (tableList.isNotEmpty)
                SizedBox(
                  height: 350,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ChartLayout(
                      tableList: tableList,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              if (tableList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TableLayout(
                    tableList: tableList,
                    isCheck: state.isCheck,
                    onTapNId: (tableData) => bloc.add(
                        BlocEvent(NpciEvent.onTapNId, extra: tableData)),
                    onTapToggle: () =>
                        bloc.add(BlocEvent(NpciEvent.onTapToggle)),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
