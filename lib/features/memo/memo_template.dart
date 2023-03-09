import 'dart:io';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/map/widgets/tag_model.dart';
import 'package:mapmo/features/memo/widgets/add_image_button.dart';

class MemoTemplate extends StatefulWidget {
  const MemoTemplate({super.key});

  @override
  State<MemoTemplate> createState() => _MemoTemplateState();
}

class _MemoTemplateState extends State<MemoTemplate> {
  final double _imageHeight = 170.0;

  final TextEditingController _textEditingController =
      TextEditingController(text: "서울시 강남구 선릉로 221");

  final List<TagModel> _chipsList = [];
  Color _selectedColor = Colors.amber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  XFile? _pickedImage;

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

  void _onInputTagTap() {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "태그 선택하기",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.v10,
              Wrap(
                children: [
                  for (var chip in _chipsList)
                    FilterChip(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      selectedColor: chip.color.withOpacity(0.9),
                      selected: chip.isSelected,
                      label: Text(chip.label),
                      side: BorderSide(color: chip.color),
                      onSelected: (value) => setState(() {
                        chip.isSelected = value;
                      }),
                    ),
                  ActionChip(
                      label: const Text("추가하기"),
                      avatar: const Icon(Icons.add),
                      onPressed: _onAddTagTap),
                ],
              ),
              Gaps.v10,
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
                "태그 추가",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.v14,
              const Text("이름"),
              Gaps.h5,
              const SizedBox(
                height: Sizes.size36,
                width: 150,
                child: Expanded(
                  child: TextField(
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                    ),
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
                    onPressed: () => Navigator.of(context).pop(),
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
                    onPressed: () => Navigator.of(context).pop(),
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

  void _onClosePress() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final phoneSize = MediaQuery.of(context).size;

    return Container(
      height: phoneSize.height * 0.75,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("장소 추가"),
          leading: IconButton(
            onPressed: _onClosePress,
            icon: const Icon(Icons.close),
          ),
          actions: [
            TextButton(
              onPressed: () {},
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
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size16,
            vertical: Sizes.size5,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _onInputImageTap,
                  child: SizedBox(
                    height:
                        (_pickedImage == null) ? Sizes.size96 : _imageHeight,
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
                            height: _imageHeight,
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
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "이곳은 어디인가요?",
                        ),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData['name'] = newValue;
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
                        controller: _textEditingController,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          //hintText: "이곳은 어디인가요?",
                        ),
                        onSaved: (newValue) {
                          if (newValue != null) {
                            formData['name'] = newValue;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Gaps.v14,
                Row(
                  children: [
                    const Text(
                      "태그",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size16,
                      ),
                    ),
                    Gaps.h10,
                    if (_chipsList.isEmpty)
                      GestureDetector(
                        onTap: _onInputTagTap,
                        child: Text(
                          '태그를 달아주세요!',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      )
                    else
                      Wrap(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
