import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';

import '../../../../domain/model/chart_data.dart';

class ChartView extends StatelessWidget {
  final List<MeasureData> measureDataList;

  const ChartView({
    required this.measureDataList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var maxIndex = measureDataList
        .reduce((value, element) =>
            value.inIndex > element.inIndex ? value : element)
        .inIndex;
    maxIndex = (maxIndex / 100).ceil() * 100;

    // measureDataList에서 inIndex 기준으로 가장 큰 값 25개를 추출
    List<MeasureData> top25MeasureData = measureDataList
      ..sort((a, b) => b.inIndex.compareTo(a.inIndex)); // inIndex 기준 내림차순 정렬
    // 상위 25개 데이터 가져오기
    top25MeasureData = top25MeasureData.take(25).toList();

    return BarChart(
      BarChartData(
        maxY: maxIndex,
        barGroups: top25MeasureData
            .mapIndexed(
              (index, e) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: e.inIndex,
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
                top25MeasureData[value.toInt()].pci.toString(),
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
            getTooltipColor: (groupData) {
              return Colors.transparent;
            },
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
