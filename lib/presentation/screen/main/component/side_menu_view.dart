import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/area/area_rename_data.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/main/component/remove_dialog.dart';
import 'package:googlemap/presentation/screen/main/component/rename_dialog.dart';
import 'package:googlemap/presentation/screen/main/component/side_header.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_bloc.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';

import 'side_body.dart';

class SideMenuView extends StatelessWidget {
  final MainBloc bloc;
  final MainState state;
  final VoidCallback onTapMenu;

  const SideMenuView({
    super.key,
    required this.bloc,
    required this.state,
    required this.onTapMenu,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: 400,
      height: height,
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              SideHeader(
                onSearch: (search) {
                  bloc.add(BlocEvent(
                    MainEvent.onSearch,
                    extra: search,
                  ));
                },
                onTapWirelessType: (type) => bloc.add(
                  BlocEvent(
                    MainEvent.onTapType,
                    extra: type,
                  ),
                ),
                onTapRefresh: () => bloc.add(BlocEvent(
                  MainEvent.onTapRefresh,
                )),
                onTapMenu: onTapMenu,
                // () => bloc.add(BlocEvent(MainEvent.onTapMenu)),
                group: state.userData?.userId ?? '',
              ),
              Expanded(
                child: KeyboardListener(
                  focusNode: bloc.focusNode,
                  onKeyEvent: (event) {
                    if (event.logicalKey == LogicalKeyboardKey.shiftLeft) {
                      bloc.add(BlocEvent(
                        MainEvent.onTapShiftKey,
                        extra: event is KeyDownEvent,
                      ));
                    }
                  },
                  child: SideBody(
                    selectedPlaceSet: state.selectedAreaDataSet,
                    areaDataList: state.filteredAreaDataList,
                    onTapItem: (value) {
                      bloc.focusNode.requestFocus();
                      bloc.add(
                        BlocEvent(
                          MainEvent.onTapItem,
                          extra: value,
                        ),
                      );
                    },
                    onTapAll: (value) {
                      bloc.add(
                        BlocEvent(
                          MainEvent.onTapItemAll,
                          extra: value,
                        ),
                      );
                    },
                    onTapRemove: (value) => bloc.add(
                      BlocEvent(MainEvent.onTapItemRemove, extra: value),
                    ),
                    onTapCacheClear: (value) => bloc.add(BlocEvent(
                      MainEvent.onTapCacheClear,
                      extra: value,
                    )),
                    onTapWithShift: (value) {
                      bloc.add(
                        BlocEvent(
                          MainEvent.onTapItemWithShift,
                          extra: value,
                        ),
                      );
                    },
                    onLongPress: (AreaData value) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return RemoveDialog(
                            onRemove: () {
                              bloc.add(BlocEvent(
                                MainEvent.onDelete,
                                extra: value,
                              ));
                            },
                            description: '"${value.name}" 자료를 삭제 하시겠습니까?',
                          );
                        },
                      );
                    },
                    onAreaRename: (areaData) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return RenameDialog(
                              oldAreaName: areaData.name,
                              onRename: (newName) {
                                if (newName != areaData.name) {
                                  final areaRenameData = AreaRenameData(
                                    idx: areaData.idx,
                                    oldName: areaData.name,
                                    newName: newName,
                                  );
                                  bloc.add(BlocEvent(
                                    MainEvent.onAreaRename,
                                    extra: areaRenameData,
                                  ));
                                }
                              },
                            );
                          });
                    },
                    type: state.type,
                    onDownloadExcel: (
                      String division,
                      String type,
                      int count,
                    ) {
                      bloc.add(BlocEvent(
                        MainEvent.onDownloadExcel,
                        extra: {
                          'division': division,
                          'type': type,
                          'count': count,
                        },
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 24,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                bloc.add(BlocEvent(MainEvent.onTapUpload));
              },
              child: const Icon(
                Icons.upload_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          )
        ],
      ),
    );
  }

  String _showAreaRenameDialog() {
    return '';
  }
}
