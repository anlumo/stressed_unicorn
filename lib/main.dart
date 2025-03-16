import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stressed_unicorn/database.dart';
import 'package:stressed_unicorn/my_page_route.dart';
import 'package:stressed_unicorn/stats.dart';
import 'package:stressed_unicorn/stress_definition.dart';
import 'package:stressed_unicorn/week_selector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

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
      debugShowCheckedModeBanner: false,
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
  static const stressButtonPadding = 32.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Stressed Unicorn'),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder:
                (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(value: 'clear', child: Text('Clear')),
                  PopupMenuDivider(),
                  PopupMenuItem(value: 'import', child: Text('Import')),
                  PopupMenuItem(value: 'export', child: Text('Export')),
                ],
            onSelected: (value) async {
              switch (value) {
                case 'clear':
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Confirm Clear'),
                          content: Text('Are you sure you want to clear the database? This action cannot be undone.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Clear')),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    final count = await widget.database.clear();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$count entries deleted')));
                    }
                  }
                case 'import':
                  final result = await FilePicker.platform.pickFiles(
                    dialogTitle: 'Import database',
                    type: FileType.custom,
                    allowedExtensions: ['json'],
                    withData: true,
                  );
                  if (result != null) {
                    final json = result.files.first.bytes;
                    if (json != null && json.isNotEmpty) {
                      try {
                        final rows = await widget.database.importJson(Utf8Decoder().convert(json));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$rows entries imported')));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          final theme = Theme.of(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString(), style: TextStyle(color: theme.colorScheme.onError)),
                              backgroundColor: theme.colorScheme.error,
                            ),
                          );
                        }
                      }
                    }
                  }
                case 'export':
                  final json = await widget.database.exportJson();
                  final result = await FilePicker.platform.saveFile(
                    dialogTitle: 'Export database',
                    fileName: 'stressed_unicorn.json',
                    type: FileType.custom,
                    allowedExtensions: ['json'],
                  );
                  if (result != null) {
                    await File(result).writeAsString(json, flush: true);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Database exported')));
                    }
                  }
                default:
                // nothing to do
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final buttonHeight = (constraints.maxHeight / StressType.values.length).floorToDouble();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: StressType.values
                .map((stressType) => Expanded(child: _addButton(context, stressType, buttonHeight)))
                .toList(growable: false),
          );
        },
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

  AnimatedCrossFade _addButton(BuildContext context, StressType stressType, double stressButtonSize) {
    final theme = Theme.of(context);

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      alignment: Alignment.center,
      firstChild: Center(
        child: SizedBox(
          width: stressButtonSize,
          height: stressButtonSize,
          child: Padding(
            padding: const EdgeInsets.all(stressButtonPadding),
            child: Hero(
              tag: stressType.tag,
              child: Tooltip(
                message: stressType.tooltip,
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
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
                  label: Icon(stressType.icon, size: stressButtonSize * 0.4),
                ),
              ),
            ),
          ),
        ),
      ),
      secondChild: Center(
        child: SizedBox(
          width: stressButtonSize,
          height: stressButtonSize,
          child: Icon(Icons.check, size: stressButtonSize * 0.4, color: theme.colorScheme.tertiary),
        ),
      ),
      crossFadeState: (_showButton[stressType] ?? true) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
