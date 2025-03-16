import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stressed_unicorn/database.dart';
import 'package:stressed_unicorn/stress_definition.dart';
import 'package:stressed_unicorn/week_selector.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.database, required this.initialWeeks});

  final AppDatabase database;
  final int initialWeeks;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final ValueNotifier<List<({DateTime day, Map<StressType, int> values})>> _query = ValueNotifier(const []);
  int showWeeks = 1;

  @override
  void initState() {
    super.initState();
    showWeeks = widget.initialWeeks;

    refreshDisplay();
  }

  Future<void> refreshDisplay() async {
    final oneWeekAgo = DateTime.now().subtract(Duration(days: 7 * showWeeks));
    final select = widget.database.select(widget.database.stressItems)
      ..where((tbl) => tbl.createdAt.isBiggerThanValue(oneWeekAgo));
    final query = await select.get();
    final days = Iterable.generate(7 * showWeeks, (day) => oneWeekAgo.add(Duration(days: 7 * showWeeks - day)));

    _query.value = days
        .map((day) {
          final values = Map.fromEntries(
            StressType.values.map(
              (stressType) => MapEntry(
                stressType,
                query
                    .where(
                      (entry) =>
                          entry.stressType == stressType &&
                          entry.createdAt.year == day.year &&
                          entry.createdAt.month == day.month &&
                          entry.createdAt.day == day.day,
                    )
                    .length,
              ),
            ),
          );
          return (day: day, values: values);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Stressed Unicorn'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ValueListenableBuilder(
            valueListenable: _query,
            builder: (context, query, _) {
              return SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  intervalType: DateTimeIntervalType.days,
                  dateFormat: DateFormat.yMEd('de'),
                  isInversed: true,
                  rangePadding: ChartRangePadding.none,
                  labelAlignment: LabelAlignment.end,
                ),
                primaryYAxis: NumericAxis(interval: 1),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(isVisible: true, position: LegendPosition.right),
                series: StressType.values
                    .map(
                      (ty) => BarSeries<({DateTime day, Map<StressType, int> values}), DateTime>(
                        dataSource: query,
                        xValueMapper: (({DateTime day, Map<StressType, int> values}) data, _) => data.day,
                        yValueMapper: (({DateTime day, Map<StressType, int> values}) data, _) => data.values[ty] ?? 0,
                        name: stressDefinition[ty]!.legendName,
                        color: stressDefinition[ty]!.barColor,
                        animationDuration: 100,
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: WeekSelector(
        weeks: showWeeks,
        database: widget.database,
        onSelectionChanged: (weeks) {
          if (weeks == 0) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              showWeeks = weeks;
              refreshDisplay();
            });
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: StressType.values.map((stressType) => _addButton(context, stressType)).toList(growable: false),
      ),
    );
  }

  FloatingActionButton _addButton(BuildContext context, StressType stressType) {
    return FloatingActionButton(
      heroTag: stressDefinition[stressType]!.tag,
      onPressed: () async {
        await widget.database
            .into(widget.database.stressItems)
            .insert(StressItemsCompanion.insert(stressType: stressType, createdAt: DateTime.now()));
        await refreshDisplay();
      },
      tooltip: stressDefinition[stressType]!.tooltip,
      child: Icon(stressDefinition[stressType]!.icon),
    );
  }
}
