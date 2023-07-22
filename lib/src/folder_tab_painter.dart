import 'package:flutter/material.dart';
import 'package:folder_tab/src/tab_model.dart';
import 'package:folder_tab/src/folder_tab_configurator.dart';

enum SelectedTabPosition {
  left,
  middle,
  right;

  static SelectedTabPosition valueFrom(int index, int tabsLength) {
    if (index == 0) {
      return SelectedTabPosition.left;
    } else if (index == tabsLength - 1) {
      return SelectedTabPosition.right;
    } else {
      return SelectedTabPosition.middle;
    }
  }
}

class FolderTabPainter extends CustomPainter {
  FolderTabConfigurator config;
  final List<TabModel> tabs;

  FolderTabPainter(this.config, this.tabs);

  @override
  void paint(Canvas canvas, Size size) {
    Paint mainPaint = _getPaintWith(tabs[config.initialTabIndex].color);

    var tabSize = Size(
      size.width / (tabs.length > 1 ? tabs.length : 3),
      config.tabHeight,
    );
    const tabCornerRadiusSize = 14.0; // 14 x 14

    // Bottom part of folder drawing
    var mainPath = Path()
      ..moveTo(0, tabSize.height + config.radius)
      ..lineTo(0, size.height - config.radius)
      ..quadraticBezierTo(0, size.height, config.radius, size.height)
      ..lineTo(size.width - config.radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - config.radius)
      ..lineTo(size.width, size.height - (size.height - (tabSize.height + config.radius)));
    canvas.drawPath(mainPath, mainPaint);

    final tabsWithIndex = tabs.map((tab) => TabModel.fromTab(tab, tabs.indexOf(tab))).toList();
    final roundedToLeftTabs = tabsWithIndex.sublist(0, config.initialTabIndex);
    final roundedToRightTabs = tabsWithIndex
        .sublist(config.initialTabIndex + 1, tabsWithIndex.length)
        .reversed
        .toList();
    final selelectedTab = tabsWithIndex[config.initialTabIndex];
    // var tabsPath = Path();

    // Unselected round to Right Tabs drawing
    roundedToRightTabs.forEach((tab) {
      Paint paint = _getPaintWith(tab.color.withOpacity(0.5));
      final isLastTab = tab.index == tabs.length - 1;
      final endYPoint = isLastTab ? tabSize.height + config.radius : tabSize.height;
      final startXPoint = tabSize.width * tab.index;
      var path = Path()
        ..moveTo(startXPoint - config.radius, 0)
        ..lineTo((startXPoint + tabSize.width) - config.radius, 0)
        ..quadraticBezierTo(startXPoint + tabSize.width, 0,
            startXPoint + tabSize.width, config.radius)
        ..lineTo(startXPoint + tabSize.width, endYPoint);

      canvas.drawPath(path, paint);
    });

    // Unselected round to Left Tabs drawing
    roundedToLeftTabs.forEach((tab) {
      Paint paint = _getPaintWith(tab.color.withAlpha(127));
      final isFirstTab = tab.index == 0;
      final startYPoint = isFirstTab ? tabSize.height + config.radius : tabSize.height;
      final startXPoint = tabSize.width * tab.index;
      var path = Path()
        ..moveTo(startXPoint, startYPoint)
        ..lineTo(startXPoint, config.radius)
        ..quadraticBezierTo(startXPoint, 0, startXPoint + config.radius, 0)
        ..lineTo(startXPoint + tabSize.width + config.radius, 0);

      canvas.drawPath(path, paint);
    });

    // Selected Tab drawing
    var path = Path();
    Paint paint = _getPaintWith(selelectedTab.color);
    final startXPoint = tabSize.width * selelectedTab.index;

    switch (SelectedTabPosition.valueFrom(selelectedTab.index, tabs.length)) {
      case SelectedTabPosition.left:
        break;
      case SelectedTabPosition.right:
        break;
      case SelectedTabPosition.middle:
        path
          ..moveTo(0, tabSize.height + config.radius)
          ..quadraticBezierTo(0, tabSize.height, config.radius, tabSize.height)
          ..lineTo(startXPoint - tabCornerRadiusSize, tabSize.height)
          ..quadraticBezierTo(startXPoint, tabSize.height, startXPoint,
              tabSize.height - tabCornerRadiusSize)
          ..lineTo(startXPoint, config.radius)
          ..quadraticBezierTo(startXPoint, 0, startXPoint + config.radius, 0)
          ..lineTo(startXPoint + (tabSize.width - config.radius), 0)
          ..quadraticBezierTo(startXPoint + tabSize.width, 0,
              startXPoint + tabSize.width, tabCornerRadiusSize)
          ..lineTo(startXPoint + tabSize.width, tabSize.height - tabCornerRadiusSize)
          ..quadraticBezierTo(startXPoint + tabSize.width, tabSize.height,
              startXPoint + tabSize.width + tabCornerRadiusSize, tabSize.height)
          ..lineTo(size.width - config.radius, tabSize.height)
          ..quadraticBezierTo(
              size.width, tabSize.height, size.width, tabSize.height + config.radius);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  Paint _getPaintWith(Color color) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.miter;

    return paint;
  }
}
