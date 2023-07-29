import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/chart_data.dart';

class ChartView extends StatelessWidget {
  final List<ChartData> charList;

  const ChartView({
    required this.charList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var maxIndex = charList.reduce((value, element) => value.index > element.index ? value : element).index;
    maxIndex = (maxIndex / 100).ceil() * 100;

    return BarChart(
      BarChartData(
        maxY: maxIndex,
        barGroups: charList
            .mapIndexed(
              (index, e) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: e.index,
                    borderRadius: BorderRadius.zero,
                    color: e.hasColor ? Colors.red : Colors.blue,
                    width: 50,
                  ),
                ],
                showingTooltipIndicators: [0],
              ),
            )
            .toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                charList[value.toInt()].pci.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 0.0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                BarTooltipItem(
              rod.toY.toString(),
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

/*

[
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: 10.toDouble(),
                borderRadius: BorderRadius.zero,
                color: Colors.red,
                width: 50,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        ]
 */
