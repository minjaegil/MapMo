import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  void _onPlusTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Add record'),
          ),
        ),
        fullscreenDialog: true,
      ),
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
