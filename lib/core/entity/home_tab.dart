import 'package:flutter/material.dart';

enum HomeTab { table, map, chart, notification }

extension HomeTabExtension on HomeTab {
  get icon {
    switch (this) {
      case HomeTab.table:
        return Icons.list;
      case HomeTab.map:
        return Icons.map;
      case HomeTab.chart:
        return Icons.show_chart;
      case HomeTab.notification:
        return Icons.notifications;
      default:
        return null;
    }
  }

  get name {
    switch (this) {
      case HomeTab.table:
        return "Table";
      case HomeTab.map:
        return "Map";
      case HomeTab.chart:
        return "Charts";
      case HomeTab.notification:
        return "Notification";
      default:
        return null;
    }
  }
}
