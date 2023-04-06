class GeocodingFeatureModel {
  /// [center] The coordinates of the feature’s center in the form [longitude,latitude]
  final List center;

  /// [placeName] A string representing the feature in the requested language, if specified
  final String placeName;

  GeocodingFeatureModel({
    //required this.relevance,
    required this.center,
    required this.placeName,
  });

  factory GeocodingFeatureModel.fromJson(Map<String, dynamic> json) {
    return GeocodingFeatureModel(
      //relevance: json['relevance'],
      center: json['center'],
      placeName: json['place_name'],
    );
  }
}
