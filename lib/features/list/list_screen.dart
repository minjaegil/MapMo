import 'package:flutter/material.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/drawer/drawer_screen.dart';
import 'package:side_sheet/side_sheet.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  void _onMenuTap(BuildContext context) async {
    await SideSheet.left(
      context: context,
      //width: MediaQuery.of(context).size.width * 0.45,
      body: const DrawerScreen(),
      barrierDismissible: true,
      sheetBorderRadius: Sizes.size14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Stack(
          children: [
            GestureDetector(
              onTap: () => _onMenuTap(context),
              child: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            const Center(
              child: Text(
                "Memo list",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size18,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(),
    );
  }
}
