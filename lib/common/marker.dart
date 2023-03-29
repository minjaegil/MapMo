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
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.stars_rounded,
            size: Sizes.size24,
            color: Colors.amber,
          ),
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
                fontSize: Sizes.size12,
                shadows: [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(1.0, 1.0),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
