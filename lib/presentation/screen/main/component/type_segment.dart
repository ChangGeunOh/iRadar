import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/wireless_type.dart';

class TypeSegment extends StatefulWidget {
  final ValueChanged onChangedValue;

  const TypeSegment({
    required this.onChangedValue,
    super.key,
  });

  @override
  State<TypeSegment> createState() => _TypeSegmentState();
}

class _TypeSegmentState extends State<TypeSegment> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TypeSegmentButton(
          title: '5G',
          index: 0,
          selected: index == 0,
          onTap: (value) {
            widget.onChangedValue(WirelessType.w5G);
            setState(() {
              index = value;
            });
          },
        ),
        const SizedBox(width: 8),
        TypeSegmentButton(
          title: 'LTE',
          index: 1,
          selected: index == 1,
          onTap: (value) {
            setState(() {
              widget.onChangedValue(WirelessType.wLte);
              index = value;
            });
          },
        ),
      ],
    );
  }
}

class TypeSegmentButton extends StatelessWidget {
  final String title;
  final int index;
  final bool selected;
  final ValueChanged onTap;

  const TypeSegmentButton({
    required this.title,
    required this.index,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTap(index),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          selected ? const Color(0xFF09AAB1) : Colors.transparent,
        ),
        fixedSize: MaterialStateProperty.all<Size>(const Size(180, 29)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
