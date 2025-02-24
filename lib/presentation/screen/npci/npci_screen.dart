import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/common/utils/mixin.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/chart/components/chart_view.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_bloc.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_event.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_state.dart';

import '../chart/components/table_view.dart';

class NpciScreen extends StatelessWidget with ShowMessageMixin {
  static String get routeName => 'npci_screen';
  final AreaData areaData;
  final String pci;
  final List<MeasureData> measureDataList;

  const NpciScreen({
    required this.areaData,
    required this.pci,
    required this.measureDataList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<NpciBloc, NpciState>(
      create: (context) => NpciBloc(
          context,
          NpciState(
            areaData: areaData,
            pci: pci,
            measureDataList: measureDataList,
          )),
      appBarBuilder: (context, bloc, state) {
        return AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(areaData.type == WirelessType.wLte
                  ? 'assets/icons/ic_lte.svg'
                  : 'assets/icons/ic_5g.svg'),
              const SizedBox(width: 16),
              Text(areaData.name),
              const SizedBox(width: 8),
              Text('PCI: $pci',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => bloc.add(BlocEvent(NpciEvent.onTapWeb)),
              icon: const Icon(
                Icons.web,
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: () => bloc.add(BlocEvent(NpciEvent.onTapExcel)),
              icon: const Icon(
                Icons.file_download,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 20),
          ],
        );
      },
      builder: (context, bloc, state) {
        if (state.message.isNotEmpty) {
          showToast(state.message);
          bloc.add(BlocEvent(NpciEvent.onMessage, extra: ''));
        }
        return Stack(
          children: [
            ListView(
              children: [
                const SizedBox(height: 24),
                if (state.measureDataList.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: ChartView(
                      measureDataList: state.measureDataList,
                    ),
                  ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 24.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    '※ 전체 루트 (참조용)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (state.measureDataList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Center(
                      child: TableView(
                        type: state.areaData.type!,
                        measureDataList: state.measureDataList,
                        onChange: (measureDataList) {},
                        onTapNId: (tableData) {},
                        onTapPci: (pci) {},
                        onTapNPci: (npci) {},
                        isNpci: true,
                      ),
                    ),
                  ),
              ],
            ),
            if (state.isLoading)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
