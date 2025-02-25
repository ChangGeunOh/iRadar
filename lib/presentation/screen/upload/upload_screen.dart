import 'package:flutter/material.dart';

import '../../../common/utils/mixin.dart';
import '../../../domain/bloc/bloc_event.dart';
import '../../../domain/bloc/bloc_scaffold.dart';
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
              Column(
                children: [
                  TopLayout(
                    onTapUpload: (data) {
                      bloc.add(BlocEvent(UploadEvent.onTapSave, extra: data));
                    },
                    onChangedData: (data) {
                      bloc.add(
                        BlocEvent(
                          UploadEvent.onChangedData,
                          extra: data,
                        ),
                      );
                    },
                    onChangeLoading: (value) {
                      bloc.add(BlocEvent(
                        UploadEvent.onLoading,
                        extra: value,
                      ));
                    },
                  ),
                  const SizedBox(height: 24),
                  if (state.excelFile != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: TableLayout(
                          intfTtList:
                              state.excelFile!.measureUploadData.intfTTList,
                        ),
                      ),
                    ),
                  if (state.excelFile == null) const Spacer(),
                  const SizedBox(height: 16),
                ],
              ),
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}
