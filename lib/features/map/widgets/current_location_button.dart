import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapmo/constants/sizes.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.size32,
      height: Sizes.size32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size5),
        color: Colors.white,
      ),
      child: const Icon(
        Icons.location_searching,
        color: Colors.black,
        size: Sizes.size18,
      ),
    );
  }
}
