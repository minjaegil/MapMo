import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmo/models/tag_model.dart';

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
