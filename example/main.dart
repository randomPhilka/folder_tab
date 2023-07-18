import 'package:flutter/material.dart';
import 'package:folder_tab/folder_tab.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final config = FolderTabConfigurator();
  final tabs = [
    TabModel(
      Colors.blueAccent,
      'Test1',
      ColoredBox(
        color: Colors.deepOrange,
      ),
    ),
        TabModel(
      Colors.redAccent,
      'Test2',
      ColoredBox(
        color: Colors.purple,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: AspectRatio(
        aspectRatio: 10 / 8,
        child: FolderTab(),
      ),
    );
  }
}
