import 'dart:collection';

import 'package:flutter/material.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapmo/models/place_model.dart';
import 'package:mapmo/models/tag_model.dart';

class SavedPlacesModel extends ChangeNotifier {
  final List<PlaceModel> _savedPlaces = [];

  String _mapName = "내 지도";

  final Map<TagModel, List<PlaceModel>> _savedTags = {
    TagModel(label: "골프", color: Colors.green): [],
    TagModel(label: "양식", color: Colors.blueGrey): [],
    TagModel(label: "일식", color: Colors.deepOrange): [],
  };

  final Map<PlaceModel, Marker> _markers = {};

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<PlaceModel> get savedPlaces =>
      UnmodifiableListView(_savedPlaces);

  UnmodifiableListView<TagModel> get savedTagsList => tagMapToList();

  String get mapName => _mapName;

  UnmodifiableListView<Marker> get savedMarkers => markerMapToList();

  /// Adds [PlaceModel] to list. This and [remove] are the only ways to modify the list from the outside.
  Future<void> add(PlaceModel place, Marker marker) async {
    _savedPlaces.add(place);
    // add tags
    if (place.tags != null) {
      for (var tag in place.tags!) {
        //tag.isSelectedAsTag = false; // tag선택 초기화; 안하면 태그추가 할 때 선택돼 있음.
        if (_savedTags.containsKey(tag)) {
          _savedTags[tag]!.add(place);
        } else {
          _savedTags[tag] = [place];
        }
      }
    }

    if (place.location != null) {
      _markers[place] = marker;
    }
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // placemodel에 태그 변경 시 savedtagslist도 변경
  void addTag(TagModel tag, PlaceModel place) {
    //tag.isSelectedAsTag = false;
    if (_savedTags.containsKey(tag)) {
      _savedTags[tag]!.add(place);
    } else {
      _savedTags[tag] = [place];
    }
    notifyListeners();
  }

  void removeTag(TagModel tag, PlaceModel place) {
    if (_savedTags.containsKey(tag)) {
      _savedTags[tag]!.remove(place);
      if (_savedTags[tag]!.isEmpty) {
        _savedTags.remove(tag);
      }
    }
  }

  void remove(PlaceModel place) {
    _savedPlaces.remove(place);
    if (place.tags != null) {
      for (var tag in place.tags!) {
        _savedTags[tag]!.remove(place);
        if (_savedTags[tag]!.isEmpty) {
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

  UnmodifiableSetView<Marker> filteredMarkerSet() {
    Set<PlaceModel> selectedPlaces = _markers.keys.toSet();
    Set<Marker> filteredMarker = {};
    for (var tag in _savedTags.keys) {
      if (tag.isSelectedAsFilter) {
        selectedPlaces = selectedPlaces.intersection(_savedTags[tag]!.toSet());
      }
    }
    if (selectedPlaces.isEmpty) {
      return UnmodifiableSetView(filteredMarker);
    }
    for (var place in selectedPlaces) {
      filteredMarker.add(_markers[place]!);
    }
    return UnmodifiableSetView(filteredMarker);
  }

  void clearFilterSelection() {
    for (var tag in _savedTags.keys) {
      if (tag.isSelectedAsFilter) {
        tag.isSelectedAsFilter = !tag.isSelectedAsFilter;
      }
    }
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
    //markersToShow.add(marker);
    _markers[temp] = marker;
    notifyListeners();
  }

  void removeTempMarker(PlaceModel temp) {
    //markersToShow.remove(_markers[temp]);
    _markers.remove(temp);
    notifyListeners();
  }

  /* String selectedFiltersToString() {
    String textToReturn = "";
    for (var tag in _savedTags.keys) {
      if (tag.isSelectedAsFilter) {
        textToReturn += tag.label;
      }
      
    }
  } */
}
