import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapmo/common/drawer/drawer_screen.dart';
import 'package:mapmo/common/place_search/place_search_screen.dart';
import 'package:mapmo/features/memo/memo_template.dart';
import 'package:mapmo/models/saved_maps.dart';

//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmo/service/api_constants.dart';

import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';

import 'package:mapmo/features/map/widgets/current_location_button.dart';

import 'package:mapmo/service/geocoding_service.dart';
import 'package:side_sheet/side_sheet.dart';

class MapScreen extends StatefulWidget {
  final SavedMaps savedMaps;
  const MapScreen({
    super.key,
    required this.savedMaps,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  LatLng _currentPosition = ApiConstants.myLocation;
  final _mapController = MapController();
  GeocodingFeature? passedGeofeature;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _animatedMapMove(_currentPosition, _mapController.zoom);
        print(passedGeofeature?.placeName);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _onMenuTap(BuildContext context) async {
    await SideSheet.left(
      context: context,
      //width: MediaQuery.of(context).size.width * 0.65,
      body: DrawerScreen(mapsList: widget.savedMaps),
      barrierDismissible: true,
      sheetBorderRadius: Sizes.size14,
    );
  }

  void _onSearchBarTap() async {
    //FocusScope.of(context).unfocus();
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PlaceSearchScreen()));
    setState(() {
      passedGeofeature = result;
    });
  }

  void _onPlusTap() async {
    await showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true, // bottom sheet의 사이즈를 조절할 수 있게해줌.
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Sizes.size14,
          ),
        ),
      ),
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              15, // keyboard가 textfield 가리지 않게
        ),
        child: DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.8,
          initialChildSize: 0.75,
          minChildSize: 0.3,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: MemoTemplate(
                savedTagsList: widget.savedMaps.currentMap.savedTagsList),
          ),
        ),
      ),
    ).then(
      (placeModelReturned) => setState(() {
        if (placeModelReturned != null) {
          widget.savedMaps.currentMap.add(placeModelReturned);
        } else {
          // tag선택 초기화; 안하면 태그추가 할 때 선택돼 있음.
          for (var tag in widget.savedMaps.currentMap.savedTagsList) {
            tag.isSelectedAsTag = false;
          }
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const mapStyleId = ApiConstants.mapBoxStyleId;
    const mapAccessToken = ApiConstants.mapBoxAccessToken;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 13,
              center: _currentPosition,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/minjaegil/$mapStyleId/tiles/256/{z}/{x}/{y}@2x?access_token=$mapAccessToken",
                additionalOptions: const {
                  'mapStyleId': mapStyleId,
                  'accessToken': mapAccessToken,
                },
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 15,
            child: SafeArea(
              child: FloatingActionButton(
                onPressed: () => _onPlusTap(),
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.add_location_alt_outlined,
                  color: Theme.of(context).primaryColor,
                  size: Sizes.size28,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 360,
                    height: Sizes.size52,
                    padding: const EdgeInsets.only(
                      left: Sizes.size12,
                      right: Sizes.size6,
                      top: Sizes.size5,
                      bottom: Sizes.size5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Sizes.size10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _onMenuTap(context),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.black,
                          ),
                        ),
                        Gaps.h14,
                        SizedBox(
                          width: 300,
                          child: GestureDetector(
                            onTap: _onSearchBarTap,
                            child: TextField(
                              enabled: false,
                              //controller: _textEditingController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                  left: Sizes.size12,
                                  top: Sizes.size16,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                hintText: "Search places here",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: const Icon(
                                  Icons.search,
                                  size: Sizes.size28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      itemCount: widget.savedMaps.currentMap.savedTagsList
                          .length, //_allChipsList.length,
                      separatorBuilder: (context, index) => Gaps.h7,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return FilterChip(
                          elevation: 1,
                          backgroundColor: Colors.white,
                          showCheckmark: false,
                          selectedColor: widget
                              .savedMaps.currentMap.savedTagsList[index].color
                              .withOpacity(0.9),
                          selected: widget.savedMaps.currentMap
                              .savedTagsList[index].isSelectedAsFilter,
                          label: Text(widget
                              .savedMaps.currentMap.savedTagsList[index].label),
                          side: BorderSide(
                              color: widget.savedMaps.currentMap
                                  .savedTagsList[index].color),
                          onSelected: (value) => setState(() {
                            widget.savedMaps.currentMap.savedTagsList[index]
                                .isSelectedAsFilter = value;
                          }),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _getCurrentPosition,
                      child: const CurrentLocationButton(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
