import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:stressed_unicorn/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('de', null);

  final database = AppDatabase();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});

  final AppDatabase database;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stressed Unicorn',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: MyHomePage(database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.database});

  final AppDatabase database;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<List<({DateTime day, int mental, int physical})>> _query = ValueNotifier(const []);
  int showWeeks = 1;

  @override
  void initState() {
    super.initState();

    refreshDisplay();
  }

  Future<void> refreshDisplay() async {
    final oneWeekAgo = DateTime.now().subtract(Duration(days: 7 * showWeeks));
    final select = widget.database.select(widget.database.stressItems)
      ..where((tbl) => tbl.createdAt.isBiggerThanValue(oneWeekAgo));
    final query = await select.get();
    final daysSet =
        query.map((entry) => DateTime(entry.createdAt.year, entry.createdAt.month, entry.createdAt.day)).toSet();
    final days = daysSet.toList();
    days.sort((a, b) => a.isAfter(b) ? 1 : -1);

    _query.value = days
        .map((day) {
          final mentalCount =
              query.where((entry) => entry.stressType == StressType.mental && entry.createdAt.day == day.day).length;
          final physicalCount =
              query.where((entry) => entry.stressType == StressType.physical && entry.createdAt.day == day.day).length;
          return (day: day, mental: mentalCount, physical: physicalCount);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('Stressed Unicorn')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: ValueListenableBuilder(
            valueListenable: _query,
            builder: (context, query, _) {
              return SfCartesianChart(
                primaryXAxis: DateTimeAxis(intervalType: DateTimeIntervalType.days, dateFormat: DateFormat.yMd('de')),
                primaryYAxis: NumericAxis(interval: 1),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(isVisible: true),
                series: <CartesianSeries<({DateTime day, int mental, int physical}), DateTime>>[
                  BarSeries<({DateTime day, int mental, int physical}), DateTime>(
                    dataSource: query,
                    xValueMapper: (({DateTime day, int mental, int physical}) data, _) => data.day,
                    yValueMapper: (({DateTime day, int mental, int physical}) data, _) => data.physical,
                    name: 'Physical Stress',
                    color: Colors.deepOrange,
                  ),
                  BarSeries<({DateTime day, int mental, int physical}), DateTime>(
                    dataSource: query,
                    xValueMapper: (({DateTime day, int mental, int physical}) data, _) => data.day,
                    yValueMapper: (({DateTime day, int mental, int physical}) data, _) => data.mental,
                    name: 'Mental Stress',
                    color: Colors.deepPurple,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton(
              segments: [
                ButtonSegment<int>(value: 1, label: Text('1 week')),
                ButtonSegment<int>(value: 4, label: Text('4 weeks')),
                ButtonSegment<int>(value: 8, label: Text('8 weeks')),
              ],
              selected: {showWeeks},
              onSelectionChanged: (weeks) {
                setState(() {
                  showWeeks = weeks.first;
                  refreshDisplay();
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await widget.database
                  .into(widget.database.stressItems)
                  .insert(StressItemsCompanion.insert(stressType: StressType.mental, createdAt: DateTime.now()));
              await refreshDisplay();
            },
            tooltip: 'Mental Stress',
            child: const Icon(Icons.psychology),
          ),
          FloatingActionButton(
            onPressed: () async {
              await widget.database
                  .into(widget.database.stressItems)
                  .insert(StressItemsCompanion.insert(stressType: StressType.physical, createdAt: DateTime.now()));
              await refreshDisplay();
            },
            tooltip: 'Physical Stress',
            child: const Icon(Icons.fitness_center),
          ),
        ],
      ),
    );
  }
}
