import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../domain/model/table_data.dart';

class ChartLayout extends StatelessWidget {
  final List<TableData> tableList;

  const ChartLayout({
    required this.tableList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final maxIndex = tableList.length > 1
        ? tableList.reduce((value, element) =>
            double.parse(value.index) > double.parse(element.index)
                ? value
                : element)
        : tableList.first;
    final maxY = (double.parse(maxIndex.index) / 100).ceil() * 100.0;

    final chartList = tableList
        .mapIndexed(
          (index, e) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: double.parse(e.index),
                borderRadius: BorderRadius.zero,
                color: e.hasColor ? Colors.red : Colors.blue,
                width: 50,
              )
            ],
            showingTooltipIndicators: [0],
          ),
        )
        .toList();
    if (chartList.isEmpty) {
      return const SizedBox();
    }
    return BarChart(
      BarChartData(
        maxY: maxY,
        barGroups: chartList,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                tableList[value.toInt()].pci.toString(),
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
