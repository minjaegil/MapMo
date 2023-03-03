import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapmo/features/map/widgets/memo_template.dart';

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
    return ElevatedButton(
      onPressed: () => _onPlusTap(),
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          const CircleBorder(),
        ),
        padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.green;
          }
          return null;
        }),
      ),
      child: const FaIcon(
        FontAwesomeIcons.plus,
      ),
    );
  }
}
