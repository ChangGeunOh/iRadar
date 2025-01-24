import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/map/area_data.dart';

import 'area_dialog.dart';

class MeasureEditText extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? label;
  final double? labelFontSize;
  final String? value;
  final double? valueFontSize;
  final bool? enabled;
  final Widget? suffixIcon;
  final Function(AreaData?) onChangedArea;

  const MeasureEditText({
    required this.onChanged,
    this.label,
    this.labelFontSize,
    this.value,
    this.valueFontSize,
    this.enabled,
    this.suffixIcon,
    required this.onChangedArea,
    super.key,
  });

  @override
  State<MeasureEditText> createState() => _MeasureEditTextState();
}

class _MeasureEditTextState extends State<MeasureEditText> {
  late TextEditingController controller;
  AreaData? areaData;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void didUpdateWidget(MeasureEditText oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget>${widget.value} :: ${oldWidget.value}');
    if (widget.value != oldWidget.value) {
      setState(() {
        controller.text = widget.value!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.label!,
              style: TextStyle(
                color: Colors.black87,
                fontSize: widget.labelFontSize ?? 14.0,
              ),
            ),
          ),
        if (widget.label != null) const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: widget.enabled ?? true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  4.0), // Adjust the radius to your liking
            ),
            suffixIcon: _suffixIcon(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          ),
          onChanged: widget.onChanged,
          style: TextStyle(
            fontSize: widget.valueFontSize ?? 16.0,
          ),
        ),
      ],
    );
  }

  Widget _suffixIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (areaData != null)
          IconButton(
            onPressed: () {
              controller.clear();
              areaData = null;
              widget.onChanged('');
              setState(() {});
            },
            icon: const Icon(Icons.clear),
          ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () async {
            final areaData = await showDialog(
                context: context,
                builder: (context) {
                  return const AreaDialog();
                });
            if (areaData != null) {
              widget.onChangedArea(areaData);
              widget.onChanged(areaData.name);
              setState(() {
                // controller.text = areaData.name;
                controller.value = controller.value.copyWith(
                  text: areaData.name,
                  selection: TextSelection.collapsed(offset: areaData.name.length),
                );
                this.areaData = areaData;
              });
            }
          },
          icon: const Icon(Icons.search),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
