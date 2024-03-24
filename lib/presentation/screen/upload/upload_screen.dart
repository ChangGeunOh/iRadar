import 'package:flutter/material.dart';
import 'package:googlemap/presentation/screen/upload/component/area_dialog.dart';

import '../../../common/utils/mixin.dart';
import '../../../domain/bloc/bloc_event.dart';
import '../../../domain/bloc/bloc_scaffold.dart';
import 'component/bottom_layout.dart';
import 'component/table_layout.dart';
import 'component/top_layout.dart';
import 'viewmodel/upload_bloc.dart';
import 'viewmodel/upload_event.dart';
import 'viewmodel/upload_state.dart';

class UploadScreen extends StatelessWidget with ShowMessageMixin {
  static String get routeName => 'upload_screen';

  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<UploadBloc, UploadState>(
      create: (context) {
        return UploadBloc(context, UploadState());
      },
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '측정데이터 업로드',
        ),
      ),
      builder: (context, bloc, state) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (state.isSearch) {
            bloc.add(BlocEvent(
              UploadEvent.onSearch,
              extra: false,
            ));
            showDialog(
              context: context,
              builder: (context) {
                final areaList = state.division.isEmpty
                    ? state.areaList
                    : state.areaList
                        .where((element) =>
                            element.division.name == state.division)
                        .toList();
                return AreaDialog(
                  areaList: areaList,
                  onTapArea: (area) => bloc.add(
                    BlocEvent(
                      UploadEvent.onTapArea,
                      extra: area,
                    ),
                  ),
                );
              },
            );
          }
        });

        if (state.message.isNotEmpty) {
          showToast(state.message);
          bloc.add(BlocEvent(UploadEvent.onClearMessage));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 48.0,
            vertical: 24.0,
          ),
          child: Stack(
            children: [
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              Column(
                children: [
                  TopLayout(
                      onTapFile: () =>
                          bloc.add(BlocEvent(UploadEvent.onTapFile)),
                      group: state.group,
                      division: state.division,
                      area: state.area,
                      fileName: state.fileName,
                      isDuplicate: state.isDuplicate,
                      onTapSearch: () {
                        bloc.add(BlocEvent(
                          UploadEvent.onSearch,
                          extra: true,
                        ));
                      },
                      onChangedArea: (value) => bloc.add(
                            BlocEvent(
                              UploadEvent.onChangedArea,
                              extra: value,
                            ),
                          ),
                      onChangedDivision: (value) => bloc.add(
                            BlocEvent(
                              UploadEvent.onChangedDivision,
                              extra: value,
                            ),
                          )),
                  const SizedBox(height: 24),
                  if (state.excelFile != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: TableLayout(
                            intfTtList:
                                state.excelFile!.measureUploadData.intfTTList,
                          ),
                        ),
                      ),
                    ),
                  if (state.excelFile == null) const Spacer(),
                  const SizedBox(height: 16),
                  BottomLayout(
                      isNoLocation: state.isNoLocation,
                      isLteOnly: state.isLteOnly,
                      isAddData: state.isAddData,
                      isWideArea: state.isWideArea,
                      onAddData: (value) => bloc.add(
                            BlocEvent(
                              UploadEvent.onChangedAddData,
                              extra: value,
                            ),
                          ),
                      onWideArea: (value) => bloc.add(
                            BlocEvent(
                              UploadEvent.onChangedWide,
                              extra: value,
                            ),
                          ),
                      onChangedPassword: (value) => bloc.add(
                            BlocEvent(
                              UploadEvent.onChangedPassword,
                              extra: value,
                            ),
                          ),
                      enabledSave: state.enabledSave,
                      onTapSave: () {
                        bloc.add(BlocEvent(UploadEvent.onLoading, extra: true));
                        bloc.add(BlocEvent(UploadEvent.onTapSave));
                      },
                      enabledAddData: state.enabledAddData),
                ],
              ),
              // if (state.message.isNotEmpty)
              //   _showMessage(state.message, () {
              //     bloc.add(BlocEvent(UploadEvent.onDoneToast));
              //   })
            ],
          ),
        );
      },
    );
  }

  Widget _showMessage(String message, VoidCallback callback) {
    Future.delayed(const Duration(milliseconds: 2500)).then((value) {
      callback();
    });
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 48.0,
          vertical: 32.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
