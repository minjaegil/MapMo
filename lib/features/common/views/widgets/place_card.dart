import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapmo/features/memo/views/memo_screen.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/common/models/place_model.dart';
import 'package:mapmo/features/common/models/saved_maps.dart';

class PlaceCard extends StatefulWidget {
  final PlaceModel placeModel;
  final SavedMaps savedMapsInfo;
  const PlaceCard({
    super.key,
    required this.placeModel,
    required this.savedMapsInfo,
  });

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  void _onCardTap() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => MemoScreen(
              placeInfo: widget.placeModel,
              savedMapsInfo: widget.savedMapsInfo,
            ),
            fullscreenDialog: true,
          ),
        )
        .then((value) => setState(
              () {},
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: _onCardTap,
      child: Card(
        //elevation: 5,
        clipBehavior: Clip.hardEdge,

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.size8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.placeModel.image != null)
              Image(
                image: FileImage(
                  File(widget.placeModel.image!.path),
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
                widget.placeModel.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Sizes.size18,
                ),
              ),
            ),
            if (widget.placeModel.tags!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size5,
                ),
                child: Wrap(
                  spacing: Sizes.size8,
                  runSpacing: -Sizes.size8,
                  children: [
                    for (var chipData in widget.placeModel.tags!)
                      Chip(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        label: Text(chipData.label),
                        side: BorderSide(color: chipData.color),
                      ),
                  ],
                ),
              )
            else if (widget.placeModel.tags!.isEmpty ||
                widget.placeModel.tags == null)
              Gaps.v48,
          ],
        ),
      ),
    );
  }
}
