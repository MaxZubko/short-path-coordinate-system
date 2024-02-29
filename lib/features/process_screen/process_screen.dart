import 'package:flutter/material.dart';

import 'process_screen_body.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
      ),
      body: const ProcessScreenBody(),
    );
  }
}
