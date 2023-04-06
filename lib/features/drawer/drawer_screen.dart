import 'package:flutter/material.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/common/models/saved_maps.dart';

class DrawerScreen extends StatefulWidget {
  final SavedMaps mapsList;

  const DrawerScreen({
    super.key,
    required this.mapsList,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  void _onAddMapTap() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: const [
              IntrinsicHeight(
                child: TextField(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: const Text(
                "취소",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Text(
                "추가",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size3,
          horizontal: Sizes.size12,
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.settings_outlined,
                size: Sizes.size24,
              ),
            ),
            Gaps.v10,
            const CircleAvatar(
              radius: Sizes.size32,
            ),
            Gaps.v12,
            const Text("기록하는 인간"),
            Gaps.v52,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "내 지도",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size16,
                  ),
                ),
                GestureDetector(
                  onTap: _onAddMapTap,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            Gaps.v14,
            Expanded(
              child: ListView.separated(
                itemCount: widget.mapsList.savedMaps.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0.5,
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    selected: index == widget.mapsList.currentIndex,
                    selectedColor: Theme.of(context).primaryColor,
                    leading: const Icon(Icons.map_outlined),
                    title: Text(
                      widget.mapsList.savedMaps[index].mapName,
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
