import 'package:flutter/material.dart';
import 'package:mapmo/constants/sizes.dart';

class MemoTemplate extends StatelessWidget {
  const MemoTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneSize = MediaQuery.of(context).size;

    return Container(
      height: phoneSize.height * 0.75,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: const Scaffold(),
    );
  }
}
