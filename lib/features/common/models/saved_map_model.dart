import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmo/features/common/models/place_model.dart';
import 'package:mapmo/features/common/models/tag_model.dart';

class SavedMapModel {
  final String mapName;
  final Map<PlaceModel, Marker> markers;
  final Map<TagModel, List<PlaceModel>> savedTags;

  SavedMapModel({
    required this.mapName,
    required this.markers,
    required this.savedTags,
  });
}
