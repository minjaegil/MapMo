import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapmo/service/api_constants.dart';

class GeocodingFeature {
  /// [relevence] Indicates how well the returned feature matches the user's query on a scale from 0 to 1.
  //final num relevance;

  /// [center] The coordinates of the feature’s center in the form [longitude,latitude]
  final List center;

  /// [placeName] A string representing the feature in the requested language, if specified
  final String placeName;

  GeocodingFeature({
    //required this.relevance,
    required this.center,
    required this.placeName,
  });

  factory GeocodingFeature.fromJson(Map<String, dynamic> json) {
    return GeocodingFeature(
      //relevance: json['relevance'],
      center: json['center'],
      placeName: json['place_name'],
    );
  }
}

class GeocodingService {
  final mapboxAccessToken = ApiConstants.mapBoxAccessToken;

  Future<List<GeocodingFeature>> getAutoCompletePlaces(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?language=kr&access_token=$mapboxAccessToken'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<GeocodingFeature> list = [];

      for (var element in data['features']) {
        list.add(GeocodingFeature.fromJson(element));
      }
      return list;
    } else {
      throw Exception('HTTP Failed');
    }
  }
}
