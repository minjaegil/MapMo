import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mapmo/features/map/widgets/add_button.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Stack(children: const [
        Positioned(
          bottom: 110,
          right: 15,
          child: AddButton(),
        ),
      ]),
    );
  }
}
