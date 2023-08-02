import 'package:flutter/material.dart';

class StatefulSlider extends StatefulWidget {
  final ValueChanged onChangedValue;
  final double initValue;

  const StatefulSlider({
    required this.onChangedValue,
    required this.initValue,
    super.key,
  });

  @override
  State<StatefulSlider> createState() => _StatefulSliderState();
}

class _StatefulSliderState extends State<StatefulSlider> {
  var value = 10.0;

  @override
  void initState() {
    value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 10,
      max: 500,
      divisions: 490,
      value: value,
      label: value.round().toString(),
      onChanged: (value) {
        setState(() {
          this.value = value;
          widget.onChangedValue(value);
        });
      },

    );
  }
}
