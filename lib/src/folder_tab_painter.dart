import 'package:flutter/material.dart';
import 'package:folder_tab/src/tab_model.dart';
import 'package:folder_tab/src/folder_tab_configurator.dart';
import 'dart:ui';

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
  double strokeWidth = 1.5;

  FolderTabPainter(this.config, this.tabs);

  @override
  void paint(Canvas canvas, Size size) {
    Paint mainPaint = _getPaintWith(tabs[config.initialTabIndex].color);

    var tabSize = Size(
      size.width / (tabs.length > 1 ? tabs.length : 3),
      config.tabHeight,
    );
    const tabCornerRadiusSize = Size(14.0, 14.0);

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
    final roundedToRightTabs =
        tabsWithIndex.sublist(config.initialTabIndex + 1, tabsWithIndex.length).reversed.toList();
    final selelectedTab = tabsWithIndex[config.initialTabIndex];

    // Unselected round to Right Tabs drawing
    roundedToRightTabs.forEach((tab) {
      final isLastTab = tab.index == tabs.length - 1;
      final endYPoint = isLastTab ? tabSize.height + config.radius : tabSize.height;
      final startXPoint = tabSize.width * tab.index;

      Paint paint = _getPaintWith(tab.color.withOpacity(0.5));

      var path = Path()
        ..moveTo(startXPoint - config.radius, 0)
        ..lineTo((startXPoint + tabSize.width) - config.radius, 0)
        ..quadraticBezierTo(
            startXPoint + tabSize.width, 0, startXPoint + tabSize.width, config.radius)
        ..lineTo(startXPoint + tabSize.width, endYPoint);

      canvas.drawPath(path, paint);
    });

    // Unselected round to Left Tabs drawing
    roundedToLeftTabs.forEach((tab) {
      Paint paint = _getPaintWith(tab.color.withOpacity(0.5));

      var index = tab.index;
      final isFirstTab = index == 0;
      final startYPoint = isFirstTab ? tabSize.height + config.radius : tabSize.height;
      final startXPoint = tabSize.width * index;

      var drawPath = Path()
        ..moveTo(startXPoint, startYPoint)
        ..lineTo(startXPoint, config.radius)
        ..quadraticBezierTo(startXPoint, 0, startXPoint + config.radius, 0)
        ..lineTo(startXPoint + tabSize.width + config.radius, 0);

      // Crop line, if it not last tab
      if (tab.index < roundedToLeftTabs.length - 1) {
        final startClipYPoint = tab.index == 0 ? tabSize.height + config.radius : tabSize.height;
        final startClipXPoint = tabSize.width * (tab.index + 1);

        var clipPath = Path()
          ..moveTo(startXPoint - strokeWidth, startYPoint - strokeWidth)
          ..lineTo(startXPoint - strokeWidth, config.radius - strokeWidth)
          ..quadraticBezierTo(startXPoint - strokeWidth, -strokeWidth,
              startXPoint + config.radius - strokeWidth, -strokeWidth)
          ..lineTo(startXPoint + tabSize.width + config.radius + strokeWidth, -strokeWidth)
          ..quadraticBezierTo(startClipXPoint, 0, startClipXPoint, config.radius)
          ..lineTo(startClipXPoint, startClipYPoint)
          ..lineTo(tabSize.width * tab.index, startClipYPoint);

        canvas.save();
        canvas.clipPath(clipPath);
        canvas.drawPath(drawPath, paint);
        canvas.restore();
      } else {
        canvas.drawPath(drawPath, paint);
      }
    });

    // Selected Tab drawing
    var path = Path();
    Paint paint = _getPaintWith(selelectedTab.color);
    final startXPoint = tabSize.width * selelectedTab.index;

    switch (SelectedTabPosition.valueFrom(selelectedTab.index, tabs.length)) {
      case SelectedTabPosition.left:
        path
          ..moveTo(0, tabSize.height + config.radius)
          ..lineTo(0, config.radius)
          ..quadraticBezierTo(0, 0, config.radius, 0)
          ..lineTo(tabSize.width - config.radius, 0)
          ..quadraticBezierTo(tabSize.width, 0, tabSize.width, config.radius)
          ..lineTo(tabSize.width, tabSize.height - tabCornerRadiusSize.height)
          ..quadraticBezierTo(tabSize.width, tabSize.height,
              tabSize.width + tabCornerRadiusSize.width, tabSize.height)
          ..lineTo(size.width - config.radius, tabSize.height)
          ..quadraticBezierTo(
              size.width, tabSize.height, size.width, tabSize.height + config.radius);
        break;
      case SelectedTabPosition.right:
        path
          ..moveTo(0, tabSize.height + config.radius)
          ..quadraticBezierTo(0, tabSize.height, config.radius, tabSize.height)
          ..lineTo(size.width - tabSize.width - tabCornerRadiusSize.width, tabSize.height)
          ..quadraticBezierTo(size.width - tabSize.width, tabSize.height,
              size.width - tabSize.width, tabSize.height - tabCornerRadiusSize.height)
          ..lineTo(size.width - tabSize.width, tabSize.height - config.radius)
          ..quadraticBezierTo(
              size.width - tabSize.width, 0, size.width - (tabSize.width - config.radius), 0)
          ..lineTo(size.width - config.radius, 0)
          ..quadraticBezierTo(size.width, 0, size.width, config.radius)
          ..lineTo(size.width, tabSize.height + config.radius);
        break;
      case SelectedTabPosition.middle:
        path
          ..moveTo(0, tabSize.height + config.radius)
          ..quadraticBezierTo(0, tabSize.height, config.radius, tabSize.height)
          ..lineTo(startXPoint - tabCornerRadiusSize.width, tabSize.height)
          ..quadraticBezierTo(
              startXPoint, tabSize.height, startXPoint, tabSize.height - tabCornerRadiusSize.height)
          ..lineTo(startXPoint, config.radius)
          ..quadraticBezierTo(startXPoint, 0, startXPoint + config.radius, 0)
          ..lineTo(startXPoint + (tabSize.width - config.radius), 0)
          ..quadraticBezierTo(startXPoint + tabSize.width, 0, startXPoint + tabSize.width,
              tabCornerRadiusSize.height)
          ..lineTo(startXPoint + tabSize.width, tabSize.height - tabCornerRadiusSize.height)
          ..quadraticBezierTo(startXPoint + tabSize.width, tabSize.height,
              startXPoint + tabSize.width + tabCornerRadiusSize.width, tabSize.height)
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
