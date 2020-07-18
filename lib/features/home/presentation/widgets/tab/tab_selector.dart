import 'package:covid19india/core/entity/entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final HomeTab activeTab;
  final Function(HomeTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: HomeTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(HomeTab.values[index]),
      type: BottomNavigationBarType.fixed,
      items: HomeTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab.icon,
            color: Colors.grey,
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
