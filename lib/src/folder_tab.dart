import 'package:flutter/material.dart';
import 'package:folder_tab/src/folder_tab_painter.dart';
import 'package:folder_tab/src/tab_model.dart';
import 'package:folder_tab/src/folder_tab_configurator.dart';

class FolderTab extends StatefulWidget {
  FolderTabConfigurator config;
  final List<TabModel> tabs;

  FolderTab({Key? key, required this.config, required this.tabs}) : super(key: key);

  @override
  State<FolderTab> createState() => _FolderTabState();
}

class _FolderTabState extends State<FolderTab> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      foregroundPainter: FolderTabPainter(widget.config, widget.tabs),
    );
  }
}
