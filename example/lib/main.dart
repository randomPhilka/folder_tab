import 'package:flutter/material.dart';
import 'package:folder_tab/folder_tab.dart';

void main() {
  runApp(ExamplePage());
}

class ExamplePage extends StatelessWidget {
  ExamplePage({super.key});

  final config = FolderTabConfigurator(initialTabIndex: 2);
  final tabs = [
    TabModel(
     const Color(0xFF69B3D2),
      'Test0',
      Placeholder(),
    ),
    TabModel(
      const Color(0xFF896BC7),
      'Test1',
      Placeholder(),
    ),
    TabModel(
      const Color(0xFF578BF5),
      'Test2',
    Placeholder(),
    ),
    TabModel(
      const Color(0xFFED706C),
      'Test3',
    Placeholder(),
    ),
    TabModel(
      const Color(0xFF383838),
      'Test4',
    Placeholder(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: AspectRatio(
                aspectRatio: 2/2.2,
                child: FolderTab(config: config, tabs: tabs)
            ),
          ),
        ),
      ),
    );
  }
}
