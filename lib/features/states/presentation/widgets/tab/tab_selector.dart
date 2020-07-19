import 'package:covid19india/core/entity/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final StateTab activeTab;
  final Function(StateTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).accentColor;

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: StateTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(StateTab.values[index]),
      type: BottomNavigationBarType.fixed,
      items: StateTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab.icon,
            color: activeTab == tab ? accentColor : Colors.grey,
          ),
          title: Text(
            tab.name,
            style: TextStyle(color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }
}
