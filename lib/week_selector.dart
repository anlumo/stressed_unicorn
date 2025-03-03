import 'package:flutter/material.dart';
import 'package:stressed_unicorn/database.dart';

class WeekSelector extends StatelessWidget {
  const WeekSelector({super.key, required this.database, required this.onSelectionChanged, required this.weeks});

  final AppDatabase database;
  final Function(int) onSelectionChanged;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    final int selectedIndex;
    switch (weeks) {
      case 0:
        selectedIndex = 0;
      case 1:
        selectedIndex = 1;
      case 4:
        selectedIndex = 2;
      case 8:
        selectedIndex = 3;
      default:
        selectedIndex = 0;
    }

    return NavigationBar(
      selectedIndex: selectedIndex,
      destinations: [
        NavigationDestination(label: 'Home', icon: Icon(Icons.home)),
        NavigationDestination(label: '1 week', icon: Icon(Icons.calendar_today)),
        NavigationDestination(label: '4 weeks', icon: Icon(Icons.calendar_month)),
        NavigationDestination(label: '8 weeks', icon: Icon(Icons.calendar_month)),
      ],
      onDestinationSelected: (value) {
        onSelectionChanged(switch (value) {
          0 => 0,
          1 => 1,
          2 => 4,
          3 => 8,
          _ => 0,
        });
      },
    );
  }
}
