import 'package:flutter/material.dart';
import 'package:mapmo/constants/sizes.dart';

class ZoomButton extends StatelessWidget {
  final bool zoomOut;
  const ZoomButton({super.key, required this.zoomOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizes.size32,
      height: Sizes.size32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size5),
        color: Colors.white,
      ),
      child: Icon(
        zoomOut == true ? Icons.zoom_out : Icons.zoom_in,
        color: Colors.black,
        size: Sizes.size24,
      ),
    );
  }
}
