import 'package:flutter/material.dart';
import 'package:short_path_coordinate_system/features/preview_screen/preview_screen_body.dart';

class PreviewScreen extends StatelessWidget {
  final List<String> field;
  final Map<String, int> start;
  final Map<String, int> end;
  final String path;
  const PreviewScreen({
    super.key,
    required this.field,
    required this.start,
    required this.end,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
      ),
      body: PreviewScreenBody(
        field: field,
        start: start,
        end: end,
        path: path,
      ),
    );
  }
}
