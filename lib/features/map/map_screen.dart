import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapmo/common/drawer/drawer_screen.dart';
import 'package:mapmo/common/place_search/place_search_screen.dart';
import 'package:mapmo/features/map/widgets/zoom_button.dart';
import 'package:mapmo/features/memo/memo_template.dart';
import 'package:mapmo/models/place_model.dart';
import 'package:mapmo/models/saved_maps.dart';

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
  LatLng _currentLocation = ApiConstants.myLocation;

  late CameraPosition _displayPosition;

  late GoogleMapController _mapController;
  GeocodingFeature? passedGeofeature;

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _mapController.setMapStyle(value);

    _moveToCurrentPosition();
  }

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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _moveToCurrentPosition() async {
    _getCurrentPosition();
    double currentZoom = await _mapController.getZoomLevel();
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation, zoom: currentZoom),
      ),
    );
  }

  void _onZoomInTap() async {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _displayPosition.target,
          zoom: _displayPosition.zoom + 1,
        ),
      ),
    );
  }

  void _onZoomOutTap() async {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _displayPosition.target,
          zoom: _displayPosition.zoom - 1,
        ),
      ),
    );
  }

  /* void _animatedMapMove(LatLng destLocation, double destZoom) {
    
    
    /* double distance = Geolocator.distanceBetween(
        _mapController.center.latitude,
        _mapController.center.longitude,
        destLocation.latitude,
        destLocation.longitude);

    // 없으면 api crash
    if (distance > 5000) {
      _mapController.move(destLocation, destZoom - 1);
      _animatedMapMove(destLocation, destZoom);
      return;
    } */
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
  } */

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

    passedGeofeature = result;
    if (passedGeofeature != null) {
      _onPlusTap(geocodingFeature: passedGeofeature);
    }
  }

  void _onPlusTap({GeocodingFeature? geocodingFeature}) async {
    PlaceModel temp = PlaceModel(name: "temporary");
    late LatLng positionToAdd;
    if (geocodingFeature == null) {
      positionToAdd =
          LatLng(_currentLocation.latitude, _currentLocation.longitude);
    } else {
      positionToAdd =
          LatLng(passedGeofeature!.center[1], passedGeofeature!.center[0]);
    }
    widget.savedMaps.currentMap.addTempMarker(temp, positionToAdd);
    setState(() {});
    // 현재 추가하는 위치 잘 보이게 하려고 이동
    LatLng cameraMovedToShowMarker = LatLng(positionToAdd.latitude - 0.0014,
        positionToAdd.longitude); //zoom 17일때 0.0014
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: cameraMovedToShowMarker,
          zoom: 17,
          tilt: _displayPosition.tilt,
        ),
      ),
    );

    // TODO: 검색해서 찾은 장소 이름/주소 자동 입력
    if (geocodingFeature != null) {}
    PlaceModel? placeModelReturned = await showModalBottomSheet(
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
          initialChildSize: 0.62,
          minChildSize: 0.1,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: MemoTemplate(
              savedTagsList: widget.savedMaps.currentMap.savedTagsList,
              currentLocation: positionToAdd,
              placeName: geocodingFeature?.placeName,
            ),
          ),
        ),
      ),
    );

    widget.savedMaps.currentMap.removeTempMarker(temp);

    if (placeModelReturned != null) {
      // await이 없으면 마커가 늦게 생김.
      await widget.savedMaps.currentMap.add(placeModelReturned);
    } else {
      // tag선택 초기화; 안하면 태그추가 할 때 선택돼 있음.
      for (var tag in widget.savedMaps.currentMap.savedTagsList) {
        tag.isSelectedAsTag = false;
      }
    }
    setState(() {});
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 13.0,
            ),
            onCameraMove: (position) {
              setState(() {
                _displayPosition = position;
              });
            },
            markers: widget.savedMaps.currentMap.filteredMarkerSet(),
            //widget.savedMaps.currentMap.savedMarkersSet,
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
                  // search bar
                  Container(
                    constraints:
                        const BoxConstraints.expand(height: Sizes.size52),
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
                        Expanded(
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
                  // Chips
                  SizedBox(
                    height: Sizes.size52,
                    child: ListView.separated(
                      itemCount: widget.savedMaps.currentMap.savedTagsList
                          .length, //_allChipsList.length,
                      separatorBuilder: (context, index) => Gaps.h7,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return FilterChip(
                          elevation: 3,
                          backgroundColor: Colors.white,
                          showCheckmark: false,
                          selectedColor: widget
                              .savedMaps.currentMap.savedTagsList[index].color
                              .withOpacity(0.9),
                          selected: widget.savedMaps.currentMap
                              .savedTagsList[index].isSelectedAsFilter,
                          label: Text(
                            widget.savedMaps.currentMap.savedTagsList[index]
                                .label,
                          ),
                          side: BorderSide(
                              color: widget.savedMaps.currentMap
                                  .savedTagsList[index].color),
                          onSelected: (value) {
                            widget.savedMaps.currentMap.savedTagsList[index]
                                .isSelectedAsFilter = value;
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: _moveToCurrentPosition,
                      child: const CurrentLocationButton(),
                    ),
                  ),
                  Gaps.v12,
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        GestureDetector(
                            onTap: _onZoomInTap,
                            child: const ZoomButton(zoomOut: false)),
                        Gaps.v4,
                        GestureDetector(
                            onTap: _onZoomOutTap,
                            child: const ZoomButton(zoomOut: true)),
                      ],
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
