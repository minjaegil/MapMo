import 'dart:io';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/common/models/place_model.dart';
import 'package:mapmo/features/common/models/saved_maps.dart';
import 'package:mapmo/features/common/models/tag_model.dart';

class MemoScreen extends StatefulWidget {
  static const String routeName = "placeDetails";
  static const String routeURL = ":placeId";

  final PlaceModel placeInfo;
  final SavedMaps savedMapsInfo;
  const MemoScreen({
    super.key,
    required this.placeInfo,
    required this.savedMapsInfo,
  });

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  final TextEditingController _tagTextEditingController =
      TextEditingController();
  Color _selectedColor = Colors.amber;

  void _onAddNewTagTap() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size20,
            vertical: Sizes.size16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "태그 신규 추가",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.v14,
              const Text("이름"),
              Gaps.h5,
              SizedBox(
                height: Sizes.size56,
                width: 150,
                // TODO: change to formtextfield to check if there's tags with same name etc.
                child: TextField(
                  autofocus: true,
                  controller: _tagTextEditingController,
                  maxLength: 15,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              Gaps.v10,
              ColorPicker(
                // Use the screenPickerColor as start color.
                color: _selectedColor,
                // Update the screenPickerColor using the callback.
                onColorChanged: (Color color) =>
                    setState(() => _selectedColor = color),
                width: Sizes.size32,
                height: Sizes.size32,
                borderRadius: Sizes.size20,
                pickersEnabled: const {ColorPickerType.accent: false},
                enableShadesSelection: false,
                heading: const Text(
                  '색깔 선택',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      setState(() {
                        _tagTextEditingController.text = "";
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Text(
                      "취소",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      //  TODO: 새로 추가한 태그 겹치는거 안겹치게하기
                      if (_tagTextEditingController.text == "") return;
                      Navigator.of(context).pop();
                      TagModel tag = TagModel(
                        label: _tagTextEditingController.text,
                        color: _selectedColor,
                        isSelectedAsFilter: false,
                        isSelectedAsTag: false,
                      );
                      setState(() {
                        widget.placeInfo.tags!.add(tag);
                        widget.savedMapsInfo.currentMap
                            .addTag(tag, widget.placeInfo);
                        //_chipsList = _chipsList.toSet().toList();
                        _tagTextEditingController.text = "";
                      });
                    },
                    child: Text(
                      "추가",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAddTagTap() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (stfContext, stfSetState) {
          if (widget.placeInfo.tags != null) {
            for (var tag in widget.savedMapsInfo.currentMap.savedTagsList) {
              if (widget.placeInfo.tags!.contains(tag)) {
                tag.isSelectedAsTag = true;
              } else {
                tag.isSelectedAsTag = false;
              }
            }
          }

          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size20,
                vertical: Sizes.size16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "태그 추가",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Sizes.size16,
                    ),
                  ),
                  Gaps.v14,
                  Wrap(
                    spacing: Sizes.size8,
                    children: [
                      for (var chipData
                          in widget.savedMapsInfo.currentMap.savedTagsList)
                        FilterChip(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          showCheckmark: false,
                          selectedColor: chipData.color.withOpacity(0.9),
                          selected: chipData.isSelectedAsTag,
                          label: Text(chipData.label),
                          side: BorderSide(color: chipData.color),
                          onSelected: (value) => setState(() {
                            if (chipData.isSelectedAsTag == false) {
                              widget.savedMapsInfo.currentMap
                                  .addTag(chipData, widget.placeInfo);
                              stfSetState(() {
                                chipData.isSelectedAsTag = true;
                              });
                              widget.placeInfo.tags!.add(chipData);
                            } else {
                              stfSetState(() {
                                chipData.isSelectedAsTag = false;
                              });
                              widget.placeInfo.tags!.remove(chipData);
                              widget.savedMapsInfo.currentMap
                                  .removeTag(chipData, widget.placeInfo);
                            }
                          }),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "확인",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _onDeleteTap() async {
    //TODO: Navigator말고 다른 방법으로 페이지 이동하기 (route방법 적용하기)
    return await showDialog(
      context: context,
      builder: (alertctx) {
        return AlertDialog(
          content: const Text("메모를 삭제하실건가요?"),
          actions: [
            TextButton(
              onPressed: () {
                widget.savedMapsInfo.currentMap.remove(widget.placeInfo);

                Navigator.of(context).pop();
                //Navigator.of(context).popUntil((route) => route.isFirst);
                /*  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen()),
                    (Route route) => false);
 */
                //alertctx.go(MainNavigationScreen.routeName);
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: const Text(
                "예",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(alertctx).pop(),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: const Text(
                "아니요",
                style: TextStyle(
                  color: Colors.black,
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
    return Scaffold(
      body: Form(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverAppBar(
              //pinned: true,
              stretch: true,
              collapsedHeight: 60,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: (widget.placeInfo.image != null)
                    ? Image.file(
                        File(widget.placeInfo.image!.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              actions: [
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == "Delete") {
                      _onDeleteTap();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "MapView",
                      child: Row(
                        children: const [
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                          ),
                          Gaps.h6,
                          Text(
                            "지도에서 보기",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "Delete",
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          Gaps.h6,
                          Text(
                            "삭제",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(
                  left: Sizes.size12,
                  right: Sizes.size12,
                  top: Sizes.size3,
                ),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IntrinsicHeight(
                  child: TextFormField(
                    initialValue: widget.placeInfo.name,
                    cursorColor: Theme.of(context).primaryColor,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: Sizes.size32,
                    ),
                    decoration: const InputDecoration(
                      hintText: "여기는 어디인가요?",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      border: InputBorder.none,
                    ),
                    autocorrect: false,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
                child: TextFormField(
                  initialValue: widget.placeInfo.address,
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(
                    fontSize: Sizes.size14,
                  ),
                  decoration: const InputDecoration(
                    hintText: "주소를 입력해주세요.",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: InputBorder.none,
                  ),
                  autocorrect: false,
                ),
              ),
            ),
            if (widget.placeInfo.tags != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.size8),
                  child: Wrap(
                    spacing: Sizes.size8,
                    runSpacing: -Sizes.size8,
                    children: [
                      for (var chipData in widget.placeInfo.tags!)
                        Chip(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          label: Text(chipData.label),
                          side: BorderSide(color: chipData.color),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: Sizes.size16,
                          ),
                          onDeleted: () {
                            chipData.isSelectedAsTag = false;
                            widget.placeInfo.tags!.remove(chipData);
                            widget.savedMapsInfo.currentMap
                                .removeTag(chipData, widget.placeInfo);
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _onAddTagTap,
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey.shade600,
                    ),
                    label: Text(
                      "태그 선택",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _onAddNewTagTap,
                    icon: Icon(
                      Icons.new_label_outlined,
                      color: Colors.grey.shade600,
                    ),
                    label: Text(
                      "신규 추가",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: Gaps.v16,
            ),
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.size12),
                child: TextFormField(
                  initialValue: widget.placeInfo.memo,
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: const InputDecoration(
                    hintText: "메모를 입력해주세요.",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: InputBorder.none,
                  ),
                  autocorrect: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
