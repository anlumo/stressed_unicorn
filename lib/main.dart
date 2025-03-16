import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stressed_unicorn/database.dart';
import 'package:stressed_unicorn/my_page_route.dart';
import 'package:stressed_unicorn/stats.dart';
import 'package:stressed_unicorn/stress_definition.dart';
import 'package:stressed_unicorn/week_selector.dart';

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
  final Map<StressType, bool> _showButton = {};
  static const stressButtonSize = 180.0;
  static const stressButtonPadding = 32.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text('Stressed Unicorn')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 64,
            children: StressType.values.map((stressType) => _addButton(context, stressType)).toList(growable: false),
          ),
        ),
      ),
      bottomNavigationBar: WeekSelector(
        weeks: 0,
        database: widget.database,
        onSelectionChanged: (weeks) {
          if (weeks != 0) {
            Navigator.of(context).push(
              MyPageRoute(
                builder: (BuildContext context) => StatsScreen(database: widget.database, initialWeeks: weeks),
              ),
            );
          }
        },
      ),
    );
  }

  AnimatedCrossFade _addButton(BuildContext context, StressType stressType) {
    final theme = Theme.of(context);

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      firstChild: SizedBox(
        width: stressButtonSize + stressButtonPadding,
        height: stressButtonSize + stressButtonPadding,
        child: Center(
          child: SizedBox(
            width: stressButtonSize,
            height: stressButtonSize,
            child: FloatingActionButton.extended(
              heroTag: stressDefinition[stressType]!.tag,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              onPressed: () async {
                setState(() {
                  _showButton[stressType] = false;
                });
                await widget.database
                    .into(widget.database.stressItems)
                    .insert(StressItemsCompanion.insert(stressType: stressType, createdAt: DateTime.now()));
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  if (context.mounted) {
                    _showButton[stressType] = true;
                  }
                });
              },
              tooltip: stressDefinition[stressType]!.tooltip,
              label: Icon(stressDefinition[stressType]!.icon, size: 80),
            ),
          ),
        ),
      ),
      secondChild: SizedBox(
        width: stressButtonSize + stressButtonPadding,
        height: stressButtonSize + stressButtonPadding,
        child: Icon(Icons.check, size: 60, color: theme.colorScheme.tertiary),
      ),
      crossFadeState: (_showButton[stressType] ?? true) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
