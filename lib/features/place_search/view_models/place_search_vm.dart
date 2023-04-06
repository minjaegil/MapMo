import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapmo/features/place_search/models/geocoding_feature_model.dart';

class PlaceSearchViewModel extends AsyncNotifier<List<GeocodingFeatureModel>> {
  static const mapboxAccessToken =
      "pk.eyJ1IjoibWluamFlZ2lsIiwiYSI6ImNsZjZjZWN5ZjBvb2gzc213ajM3bDA4eHQifQ.BhMNSa5mvENzTEORNBz8aA";

  List<GeocodingFeatureModel> _placeAutoCompleteSuggestions = [];

  /// Gets auto-complete suggestions of user input [query] from the API.
  void getAutoCompletePlaces(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?proximity=ip&language=ko&access_token=$mapboxAccessToken'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<GeocodingFeatureModel> list = [];

      for (var element in data['features']) {
        list.add(GeocodingFeatureModel.fromJson(element));
      }
      _placeAutoCompleteSuggestions = list;
      state = AsyncValue.data(_placeAutoCompleteSuggestions);
    } else {
      throw Exception('HTTP Failed');
    }
  }

  @override
  FutureOr<List<GeocodingFeatureModel>> build() async {
    await Future.delayed(const Duration(seconds: 3));
    return _placeAutoCompleteSuggestions;
    // for testing
  }
}

final placeSearchProvider =
    AsyncNotifierProvider<PlaceSearchViewModel, List<GeocodingFeatureModel>>(
  () => PlaceSearchViewModel(),
);
