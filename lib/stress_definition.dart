import 'package:flutter/material.dart';

enum StressType { physical, mental, positive }

final class StressDefinition {
  final Symbol tag;
  final IconData icon;
  final String tooltip;
  final String legendName;
  final Color barColor;

  const StressDefinition({
    required this.tag,
    required this.icon,
    required this.tooltip,
    required this.legendName,
    required this.barColor,
  });
}

const stressDefinition = {
  StressType.mental: StressDefinition(
    tag: Symbol('mental'),
    icon: Icons.psychology,
    tooltip: 'Mental Stress',
    legendName: 'Mental',
    barColor: Colors.deepOrange,
  ),
  StressType.physical: StressDefinition(
    tag: Symbol('physical'),
    icon: Icons.woman_2,
    tooltip: 'Physical Stress',
    legendName: 'Physical',
    barColor: Colors.deepPurple,
  ),
  StressType.positive: StressDefinition(
    tag: Symbol('positive'),
    icon: Icons.thumb_up_alt,
    tooltip: 'Positive',
    legendName: 'Positive',
    barColor: Colors.blue,
  ),
};
