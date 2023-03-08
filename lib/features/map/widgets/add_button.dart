import 'package:flutter/material.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/memo/memo_template.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  void _onPlusTap() async {
    await showModalBottomSheet(
      isScrollControlled: true, // bottom sheet의 사이즈를 조절할 수 있게해줌.
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const MemoTemplate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _onPlusTap(),
      backgroundColor: Colors.white,
      child: Icon(
        Icons.add_location_alt_outlined,
        color: Theme.of(context).primaryColor,
        size: Sizes.size28,
      ),
    );
  }
}
