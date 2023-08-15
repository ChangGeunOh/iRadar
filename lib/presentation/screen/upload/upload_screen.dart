import 'package:flutter/material.dart';

import '../../../domain/bloc/bloc_event.dart';
import '../../../domain/bloc/bloc_layout.dart';
import 'component/bottom_layout.dart';
import 'component/table_layout.dart';
import 'component/top_layout.dart';
import 'viewmodel/upload_bloc.dart';
import 'viewmodel/upload_event.dart';
import 'viewmodel/upload_state.dart';

class UploadScreen extends StatelessWidget {
  static String get routeName => 'upload_screen';

  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocLayout<UploadBloc, UploadState>(
      create: (context) => UploadBloc(context, UploadState()),
      builder: (context, bloc, state) {
        print('isLoading ::: ${state.isLoading}');
        if (state.isLoading && state.excelFile == null && state.filePickerResult != null) {
          bloc.add(BlocEvent(UploadEvent.onReadExcel, extra: state.filePickerResult));
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              '측정데이터 업로드',
            ),
          ),
          body: Padding(
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
                      onChanged: (type, value) => bloc.add(
                        BlocEvent(
                          UploadEvent.onChanged,
                          extra: UploadChangeData(type: type, value: value),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state.excelFile != null)
                      Expanded(
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: TableLayout(
                              intfTtList: state.excelFile!.measureUploadData.intfTTList,
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
                          UploadEvent.onAddData,
                          extra: value,
                        ),
                      ),
                      onWideArea: (value) => bloc.add(
                        BlocEvent(
                          UploadEvent.onWideArea,
                          extra: value,
                        ),
                      ),
                      onChangedPassword: (value) => bloc.add(
                        BlocEvent(
                          UploadEvent.onChanged,
                          extra: UploadChangeData(
                            type: UploadChangedType.onPassword,
                            value: value,
                          ),
                        ),
                      ),
                      enabledSave: state.enabledSave,
                      onTapSave: ()=>bloc.add(BlocEvent(UploadEvent.onTapSave)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
