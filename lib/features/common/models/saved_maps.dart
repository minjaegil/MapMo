import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mapmo/features/common/models/saved_places_model.dart';

class SavedMaps extends ChangeNotifier {
  final List<SavedPlacesModel> _savedMaps = [SavedPlacesModel()];

  UnmodifiableListView<SavedPlacesModel> get savedMaps =>
      UnmodifiableListView(_savedMaps);

  int i = 0;
  SavedPlacesModel get currentMap => _savedMaps[i];
  int get currentIndex => i;

  void add(SavedPlacesModel placesModel) {
    _savedMaps.add(placesModel);
    notifyListeners();
  }

  void changeMap(int index) {
    i = index;
    notifyListeners();
  }

  void remove(int index) {
    if (_savedMaps.length == 1) {
      return;
    }
    _savedMaps.removeAt(index);
  }
}
