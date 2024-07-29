import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/pci/pci_base_data.dart';

class PciState  {
  final bool isLoading;
  final String message;
  final String type;
  final int idx;
  final String spci;
  final PciBaseData? pciBaseData;

  PciState({
    this.isLoading = false,
    this.message = '',
    required this.type,
    required this.idx,
    required this.spci,
    this.pciBaseData,
  });

  PciState copyWith({
    bool? isLoading,
    String? message,
    PciBaseData? pciBaseData,
  }) {
    return PciState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      idx: idx,
      spci: spci,
      type: type,
      pciBaseData: pciBaseData ?? this.pciBaseData,
    );
  }
}