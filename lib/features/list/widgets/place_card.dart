import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/models/place_model.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel placeModel;
  const PlaceCard({super.key, required this.placeModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      //elevation: 5,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.size8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (placeModel.image != null)
            Image(
              image: FileImage(
                File(placeModel.image!.path),
              ),
              fit: BoxFit.cover,
              height: Sizes.imageHeight,
              width: MediaQuery.of(context).size.width,
            )
          else
            Container(
              height: Sizes.imageHeight,
              decoration: BoxDecoration(color: Colors.grey.shade200),
            ),
          Padding(
            padding: const EdgeInsets.only(
              left: Sizes.size5,
              right: Sizes.size5,
              top: Sizes.size10,
              bottom: Sizes.size2,
            ),
            child: Text(
              placeModel.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.size18,
              ),
            ),
          ),
          if (placeModel.tags!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size5,
              ),
              child: Wrap(
                spacing: Sizes.size8,
                runSpacing: -Sizes.size8,
                children: [
                  for (var chipData in placeModel.tags!)
                    Chip(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      label: Text(chipData.label),
                      side: BorderSide(color: chipData.color),
                    ),
                ],
              ),
            )
          else if (placeModel.tags!.isEmpty || placeModel.tags == null)
            Gaps.v48,
        ],
      ),
    );
  }
}
