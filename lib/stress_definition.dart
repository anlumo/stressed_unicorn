import 'package:flutter/material.dart';

enum StressType {
  physical(
    tag: Symbol('physical'),
    icon: Icons.woman_2,
    tooltip: 'Physical Stress',
    legendName: 'Physical',
    barColor: Colors.deepPurple,
  ),
  mental(
    tag: Symbol('mental'),
    icon: Icons.psychology,
    tooltip: 'Mental Stress',
    legendName: 'Mental',
    barColor: Colors.deepOrange,
  ),
  positive(
    tag: Symbol('positive'),
    icon: Icons.thumb_up_alt,
    tooltip: 'Positive',
    legendName: 'Positive',
    barColor: Colors.blue,
  );

  const StressType({
    required this.tag,
    required this.icon,
    required this.tooltip,
    required this.legendName,
    required this.barColor,
  });
  final Symbol tag;
  final IconData icon;
  final String tooltip;
  final String legendName;
  final Color barColor;
}
