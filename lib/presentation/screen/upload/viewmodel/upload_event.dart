enum UploadEvent {
  init,
  onChanged,
  onTapFile,
  onReadExcel,
  onLoading,
  onAddData,
  onWideArea,
  onTapSave,
  onDoneToast,
}

enum UploadChangedType {
  isNoLocation,
  isLteOnly,
  isWideArea,
  isAddData,
  onDivision,
  onPassword,
  onArea,
}

class UploadChangeData {
  final UploadChangedType type;
  final dynamic value;

  UploadChangeData({
    required this.type,
    required this.value,
  });
}
