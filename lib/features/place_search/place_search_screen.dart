import 'package:flutter/material.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/service/geocoding_service.dart';

class PlaceSearchScreen extends StatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  State<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  List? _placeAutoCompleteSuggestions;

  _loadAutoCompletePlaces(String query) async {
    final results = await GeocodingService().getAutoCompletePlaces(query);
    setState(() {
      _placeAutoCompleteSuggestions = results;
    });
  }

  void _onAutoCorrectPlaceTap(GeocodingFeature place) {
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
                        if (value.length > 3) _loadAutoCompletePlaces(value);
                        setState(() {});
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
            if (_placeAutoCompleteSuggestions != null)
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  GeocodingFeature place =
                      _placeAutoCompleteSuggestions![index];

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
                itemCount: _placeAutoCompleteSuggestions!.length,
              ),
          ],
        ),
      ),
    );
  }
}
