import 'package:flutter/material.dart';

enum StateTab { map, meta, bar, chart }

extension StateTabExtension on StateTab {
  get icon {
    switch (this) {
      case StateTab.map:
        return Icons.map;
      case StateTab.meta:
        return Icons.lightbulb_outline;
      case StateTab.bar:
        return Icons.insert_chart;
      case StateTab.chart:
        return Icons.show_chart;
      default:
        return null;
    }
  }

  get name {
    switch (this) {
      case StateTab.map:
        return "Map";
      case StateTab.meta:
        return "Info";
      case StateTab.bar:
        return "Districts";
      case StateTab.chart:
        return "Charts";
      default:
        return null;
    }
  }
}
