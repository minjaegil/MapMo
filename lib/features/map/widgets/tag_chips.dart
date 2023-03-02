import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapmo/constants/sizes.dart';

class TagChips extends StatelessWidget {
  const TagChips({super.key});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: const Text("golf"),
      avatar: const FaIcon(
        FontAwesomeIcons.golfBallTee,
        size: Sizes.size18,
      ),
      onSelected: (value) => () {},
    );
  }
}
