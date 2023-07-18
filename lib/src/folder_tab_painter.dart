import 'package:flutter/material.dart';
import 'package:folder_tab/src/tab_model.dart';
import 'package:folder_tab/src/folder_tab_configurator.dart';

enum TabPosition { left, middle, right }

class FolderTabPainter extends CustomPainter {
  FolderTabConfigurator config;
  final List<TabModel> tabs;

  FolderTabPainter(this.config, this.tabs);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = _getPaintWith(tabs[config.initialTabIndex].color);


    var tabSize = Size(
      size.width / (tabs.length > 1 ? tabs.length : 3),
      config.tabHeight,
    );
    const tabCornerRadiusSize = 14.0; // 14 x 14
    var initialDrawTabsXPoint = 0.0;

    var mainPath = Path()
      ..moveTo(0, tabSize.height + config.radius)
      ..lineTo(0, size.height - config.radius)
      ..quadraticBezierTo(0, size.height, config.radius, size.height)
      ..lineTo(size.width - config.radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - config.radius)
      ..lineTo(size.width, size.height - (size.height - (tabSize.height + config.radius)));

    canvas.drawPath(mainPath, paint);

    tabs.asMap().forEach((index, tab) {
      Paint paint = _getPaintWith(tab.color);
      var path = Path()
        ..moveTo(initialDrawTabsXPoint, tabSize.height);
      switch (_getTabPositionBy(index)) {
        case TabPosition.left:
          path
            ..lineTo(0, config.radius)
            ..quadraticBezierTo(0, size.height, initialDrawTabsXPoint + config.radius, 0)
            ..lineTo(size.width - config.radius, size.height);
          break;
        case TabPosition.right:
          break;
        case TabPosition.middle:
          break;
      }
      initialDrawTabsXPoint += tabSize.width;

      canvas.drawPath(path, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Paint _getPaintWith(Color color) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    return paint;
  }

  TabPosition _getTabPositionBy(int index) {
    if (index < config.initialTabIndex) {
      return TabPosition.left;
    } else if (index > config.initialTabIndex) {
      return TabPosition.right;
    } else {
      return TabPosition.middle;
    }
  }
  
}
