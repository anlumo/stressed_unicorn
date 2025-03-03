import 'package:flutter/material.dart';
import 'package:stressed_unicorn/database.dart';

class WeekSelector extends StatelessWidget {
  const WeekSelector({super.key, required this.database, required this.onSelectionChanged, required this.weeks});

  final AppDatabase database;
  final Function(int) onSelectionChanged;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SegmentedButton(
            segments: [
              ButtonSegment<int>(value: 0, label: Text('Home')),
              ButtonSegment<int>(value: 1, label: Text('1 week')),
              ButtonSegment<int>(value: 4, label: Text('4 weeks')),
              ButtonSegment<int>(value: 8, label: Text('8 weeks')),
            ],
            selected: {weeks},
            onSelectionChanged: (weeks) {
              onSelectionChanged(weeks.first);
            },
          ),
        ),
      ],
    );
  }
}
