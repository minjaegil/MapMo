import 'package:flutter/material.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/drawer/drawer_screen.dart';
import 'package:mapmo/common/place_card.dart';
import 'package:mapmo/models/saved_maps.dart';
import 'package:side_sheet/side_sheet.dart';

class ListScreen extends StatelessWidget {
  final SavedMaps savedMaps;
  const ListScreen({super.key, required this.savedMaps});

  void _onMenuTap(BuildContext context) async {
    await SideSheet.left(
      context: context,
      //width: MediaQuery.of(context).size.width * 0.45,
      body: DrawerScreen(mapsList: savedMaps),
      barrierDismissible: true,
      sheetBorderRadius: Sizes.size14,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          onTap: () => _onMenuTap(context),
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        title: const Text(
          "장소 모아보기",
          style: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size18,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size8,
          vertical: Sizes.size8,
        ),
        child: ListView.separated(
          itemCount: savedMaps.currentMap.savedPlaces.length,
          separatorBuilder: (context, index) => Gaps.h7,
          itemBuilder: (context, index) {
            return PlaceCard(
              placeModel: savedMaps.currentMap.savedPlaces[index],
              savedPlacesInfo: savedMaps.currentMap,
            );
          },
        ),
      ),
    );
  }
}
