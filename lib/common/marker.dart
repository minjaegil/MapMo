import 'package:flutter/material.dart';
import 'package:mapmo/constants/sizes.dart';

class MyMarker extends StatelessWidget {
  final String placeName;

  const MyMarker({
    super.key,
    required this.placeName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.stars_sharp,
          color: Colors.amber,
        ),
        SizedBox(
          width: Sizes.size80,
          height: Sizes.size40,
          child: Text(
            placeName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
