import 'dart:io';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/models/place_model.dart';

import 'package:mapmo/models/tag_model.dart';
import 'package:mapmo/features/memo/widgets/add_image_button.dart';

class MemoTemplate extends StatefulWidget {
  final List<TagModel> savedTagsList;
  final LatLng currentLocation;
  final String? placeName;

  const MemoTemplate({
    super.key,
    required this.savedTagsList,
    required this.currentLocation,
    this.placeName,
  });

  @override
  State<MemoTemplate> createState() => _MemoTemplateState();
}

class _MemoTemplateState extends State<MemoTemplate> {
  //SavedTagsModel _allChipsList = SavedTagsModel();
  final List<TagModel> _chipsList = [];

  Color _selectedColor = Colors.amber;
  final TextEditingController _tagTextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final PlaceModel _placeInfo = PlaceModel(name: "default name");

  XFile? _pickedImage;
  late LatLng location = widget.currentLocation;

  String _getPlaceName(String? placeName) {
    if (placeName == null) {
      return "";
    }
    int idx = placeName.indexOf(",");
    if (idx == -1) {
      return placeName;
    }
    return placeName.substring(0, idx).trim();
  }

  String _getPlaceAddress(String? placeName) {
    if (placeName == null) {
      return "";
    }
    int idx = placeName.indexOf(",");
    if (idx == -1) {
      return placeName;
    }
    return placeName.substring(idx + 1).trim();
  }

  void _getPhotoLibraryImage() async {
    Navigator.of(context).pop();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('Image not selected');
      }
    }
  }

  void _onInputImageTap() {
    showDialog(
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
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _getPhotoLibraryImage,
                child: Row(
                  children: const [
                    Icon(Icons.photo_library_outlined),
                    Gaps.h5,
                    Text("라이브러리에서 선택"),
                  ],
                ),
              ),
              Gaps.v10,
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _pickedImage = null;
                  });
                },
                child: Row(
                  children: const [
                    Icon(Icons.delete_outline),
                    Gaps.h5,
                    Text("사진 지우기"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
                        _chipsList.add(tag);
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
                      for (var chipData in widget.savedTagsList)
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
                              stfSetState(() {
                                chipData.isSelectedAsTag = true;
                              });

                              _chipsList.add(chipData);
                            } else {
                              stfSetState(() {
                                chipData.isSelectedAsTag = false;
                              });
                              _chipsList.remove(chipData);
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

  void _onClosePress() {
    Navigator.of(context).pop();
  }

  void _onSaveTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        setState(() {
          _placeInfo.image = _pickedImage;
          _placeInfo.tags = _chipsList;
          _placeInfo.location = location;
          Navigator.pop(context, _placeInfo);
        });

        //if (kDebugMode) print(_allChipsList.length);
      }
    }
  }

  @override
  void dispose() {
    _tagTextEditingController.dispose();
    //_addressTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneSize = MediaQuery.of(context).size;

    return Column(
      children: [
        Stack(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _onClosePress,
              icon: const Icon(Icons.close),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: Sizes.size14,
                ),
                child: Text(
                  "장소 추가",
                  style: TextStyle(
                    fontSize: Sizes.size18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _onSaveTap,
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size16,
            vertical: Sizes.size5,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _onInputImageTap,
                  child: SizedBox(
                    height: (_pickedImage == null)
                        ? Sizes.size96
                        : Sizes.imageHeight,
                    width: phoneSize.width,
                    child: Stack(
                      children: [
                        if (_pickedImage == null)
                          const Center(
                            child: Text('No image'),
                          )
                        else
                          Image(
                            image: FileImage(
                              File(_pickedImage!.path),
                            ),
                            fit: BoxFit.cover,
                            height: Sizes.imageHeight,
                            width: phoneSize.width,
                          ),
                        const Positioned(
                          bottom: 0,
                          right: 0,
                          child: AddImageButton(),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "이름",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size16,
                      ),
                    ),
                    Gaps.h10,
                    Expanded(
                      child: TextFormField(
                        initialValue: _getPlaceName(widget.placeName),
                        maxLines: 1,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "이곳은 어디인가요?",
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return '장소 이름은 필수사항입니다.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            _placeInfo.name = newValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "주소",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size16,
                      ),
                    ),
                    Gaps.h10,
                    Expanded(
                      child: TextFormField(
                        initialValue: _getPlaceAddress(widget.placeName),
                        maxLines: 1,
                        //controller: _addressTextEditingController,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          //hintText: "이곳은 어디인가요?",
                        ),
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return '주소는 필수사항입니다.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            _placeInfo.address = newValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                //Gaps.v8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "태그",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size16,
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
                //Gaps.v10,
                Wrap(
                  spacing: Sizes.size8,
                  runSpacing: -Sizes.size8,
                  children: [
                    for (var chipData in _chipsList)
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
                          setState(() {
                            chipData.isSelectedAsTag = false;
                            _chipsList.remove(chipData);
                          });
                        },
                      ),
                    ActionChip(
                      label: const Text("추가하기"),
                      avatar: const Icon(Icons.add),
                      onPressed: _onAddTagTap,
                    ),
                  ],
                ),
                Gaps.v10,
                const Text(
                  "메모",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v10,
                TextFormField(
                  //onTap: _onStartWriting,s
                  cursorColor: Theme.of(context).primaryColor,
                  textInputAction: TextInputAction.newline,

                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "메모를 추가하세요!",
                  ),

                  onSaved: (newValue) {
                    if (newValue != null) {
                      _placeInfo.memo = newValue;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
