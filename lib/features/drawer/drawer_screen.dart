import 'package:flutter/material.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/models/saved_maps.dart';

class DrawerScreen extends StatelessWidget {
  final SavedMaps mapsList;

  const DrawerScreen({
    super.key,
    required this.mapsList,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size3,
          horizontal: Sizes.size12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.person_outline_rounded,
                  size: Sizes.size28,
                ),
                Gaps.h10,
                Icon(
                  Icons.settings_outlined,
                  size: Sizes.size24,
                ),
              ],
            ),
            const Text(
              "Saved maps",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.size16,
              ),
            ),
            Gaps.v14,
            Expanded(
              child: ListView.separated(
                itemCount: mapsList.savedMaps.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0.5,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    selected: index == mapsList.currentIndex,
                    selectedColor: Theme.of(context).primaryColor,
                    leading: const Icon(Icons.map_outlined),
                    title: Text(
                      mapsList.savedMaps[index].mapName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text("Created by..."),
                    trailing: const Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
