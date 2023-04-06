import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mapmo/features/common/models/tag_model.dart';

class PlaceModel {
  String name;
  String? address;
  XFile? image;
  List<TagModel>? tags;
  String? memo;
  LatLng? location;

  PlaceModel({
    required this.name,
    this.address,
    this.tags,
    this.memo,
    this.image,
    this.location,
  });
}
