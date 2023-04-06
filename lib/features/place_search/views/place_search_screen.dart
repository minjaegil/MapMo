import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/place_search/models/geocoding_feature_model.dart';
import 'package:mapmo/features/place_search/view_models/place_search_vm.dart';

class PlaceSearchScreen extends ConsumerStatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  PlaceSearchScreenState createState() => PlaceSearchScreenState();
}

class PlaceSearchScreenState extends ConsumerState<PlaceSearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  void _onAutoCorrectPlaceTap(GeocodingFeatureModel place) {
    Navigator.pop(context, place);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size12,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      //size: Sizes.size28,
                    ),
                  ),
                  Gaps.h14,
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofocus: true,
                      onChanged: (value) {
                        if (value.length > 3) {
                          //_loadAutoCompletePlaces(value);
                          ref
                              .read(placeSearchProvider.notifier)
                              .getAutoCompletePlaces(value);
                        }

                        //setState(() {});
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          top: Sizes.size16,
                          left: Sizes.size12,
                        ),
                        hintText: "장소를 검색하세요",
                        hintStyle: const TextStyle(fontSize: Sizes.size18),
                        suffixIcon: _textEditingController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _textEditingController.clear();
                                  FocusScope.of(context).unfocus();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  size: Sizes.size16,
                                  color: Colors.black,
                                ),
                              ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, height: 1, color: Colors.grey.shade400),
            //Gaps.v5,
            ref.watch(placeSearchProvider).when(
                  data: (data) => ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      GeocodingFeatureModel place = data[index];

                      int idx = place.placeName.indexOf(",");
                      return ListTile(
                        minLeadingWidth: Sizes.size10,
                        leading: const Icon(Icons.place_outlined),
                        title: idx == -1
                            ? Text(place.placeName)
                            : Text(place.placeName.substring(0, idx)),
                        subtitle: idx == -1
                            ? null
                            : Text(place.placeName.substring(idx + 1).trim()),
                        onTap: () => _onAutoCorrectPlaceTap(place),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                        thickness: 0.5, height: 1, color: Colors.grey.shade300),
                    itemCount: data.length,
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Could not load places: $error',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
