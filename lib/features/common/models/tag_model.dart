import 'dart:ui';

class TagModel {
  String label;
  Color color;
  bool isSelectedAsFilter;
  bool isSelectedAsTag;

  TagModel({
    required this.label,
    required this.color,
    this.isSelectedAsFilter = false,
    this.isSelectedAsTag = false,
  });
}
