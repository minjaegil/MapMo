import 'dart:collection';

import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmo/common/marker.dart';

import 'package:mapmo/models/place_model.dart';
import 'package:mapmo/models/tag_model.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class SavedPlacesModel extends ChangeNotifier {
  final List<PlaceModel> _savedPlaces = [];

  String _mapName = "내 지도";

  final Map<TagModel, int> _savedTags = {
    TagModel(label: "한식", color: Colors.green): 1,
    TagModel(label: "양식", color: Colors.blueGrey): 1,
    TagModel(label: "일식", color: Colors.deepOrange): 1,
  };

  final Map<PlaceModel, Marker> _markers = {};

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<PlaceModel> get savedPlaces =>
      UnmodifiableListView(_savedPlaces);

  UnmodifiableListView<TagModel> get savedTagsList => tagMapToList();

  String get mapName => _mapName;

  UnmodifiableListView<Marker> get savedMarkers => markerMapToList();

  /// Adds [PlaceModel] to list. This and [remove] are the only ways to modify the list from the outside.
  void add(PlaceModel place) async {
    _savedPlaces.add(place);
    // add tags
    if (place.tags != null) {
      for (var tag in place.tags!) {
        tag.isSelectedAsTag = false; // tag선택 초기화; 안하면 태그추가 할 때 선택돼 있음.
        if (_savedTags.containsKey(tag)) {
          _savedTags[tag] = _savedTags[tag]! + 1;
        } else {
          _savedTags[tag] = 1;
        }
      }
    }
    // TODO: add markers
    if (place.location != null) {
      Marker marker = Marker(
        markerId: MarkerId(place.name),
        anchor: const Offset(0.5, 0.15),
        position: place.location!,
        icon: await MyMarker(
          placeName: place.name,
        ).toBitmapDescriptor(),
      );
      _markers[place] = marker;
    }

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void remove(PlaceModel place) {
    _savedPlaces.remove(place);
    if (place.tags != null) {
      for (var tag in place.tags!) {
        _savedTags[tag] = _savedTags[tag]! - 1;
        if (_savedTags[tag] == 0) {
          _savedTags.remove(tag);
        }
      }
    }
    _markers.remove(place);
    notifyListeners();
  }

  UnmodifiableListView<TagModel> tagMapToList() {
    return UnmodifiableListView(_savedTags.keys);
  }

  UnmodifiableListView<Marker> markerMapToList() {
    return UnmodifiableListView(_markers.values);
  }

  void setMapName(String name) {
    _mapName = name;
    notifyListeners();
  }

  void addTempMarker(PlaceModel temp, LatLng location) {
    Marker marker = Marker(
      markerId: const MarkerId("temp"),
      position: location,
    );
    _markers[temp] = marker;
    notifyListeners();
  }

  void removeTempMarker(PlaceModel temp) {
    _markers.remove(temp);
    notifyListeners();
  }
}
