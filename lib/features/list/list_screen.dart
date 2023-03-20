import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/common/drawer/drawer_screen.dart';
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
          horizontal: Sizes.size12,
          vertical: Sizes.size8,
        ),
        child: ListView.separated(
          itemCount: savedMaps.currentMap.savedPlaces.length,
          separatorBuilder: (context, index) => Gaps.h7,
          itemBuilder: (context, index) {
            return Card(
              //elevation: 5,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.size8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (savedMaps.currentMap.savedPlaces[index].image != null)
                    Image(
                      image: FileImage(
                        File(savedMaps
                            .currentMap.savedPlaces[index].image!.path),
                      ),
                      fit: BoxFit.cover,
                      height: Sizes.imageHeight,
                      width: MediaQuery.of(context).size.width,
                    )
                  else
                    Container(
                      height: Sizes.imageHeight,
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: Sizes.size5,
                      right: Sizes.size5,
                      top: Sizes.size10,
                      bottom: Sizes.size2,
                    ),
                    child: Text(
                      savedMaps.currentMap.savedPlaces[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Sizes.size18,
                      ),
                    ),
                  ),
                  if (savedMaps.currentMap.savedPlaces[index].tags!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size5,
                      ),
                      child: Wrap(
                        spacing: Sizes.size8,
                        runSpacing: -Sizes.size8,
                        children: [
                          for (var chipData
                              in savedMaps.currentMap.savedPlaces[index].tags!)
                            Chip(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              label: Text(chipData.label),
                              side: BorderSide(color: chipData.color),
                            ),
                        ],
                      ),
                    )
                  else if (savedMaps
                          .currentMap.savedPlaces[index].tags!.isEmpty ||
                      savedMaps.currentMap.savedPlaces[index].tags == null)
                    Gaps.v48,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
