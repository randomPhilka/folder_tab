import 'package:flutter/material.dart';

class TabModel {
  final Color color;
  final String title;
  final Widget child;
  int index;

  TabModel(this.color, this.title, this.child, [this.index = 0]);

  TabModel.fromTab(TabModel tab, int index)
      : color = tab.color,
        title = tab.title,
        child = tab.child,
        index = index;
}
