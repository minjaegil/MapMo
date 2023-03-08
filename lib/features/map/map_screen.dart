import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/drawer/drawer_screen.dart';
import 'package:mapmo/features/map/widgets/add_button.dart';

import 'package:side_sheet/side_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final TextEditingController _textEditingController = TextEditingController();

  final LatLng _center = const LatLng(45.521563, -122.677433);

  bool _filtercheck = false;

  void _onChipTap(bool isChecked) {
    if (isChecked) {
      print("check");
    } else {
      print("bye");
    }
    setState(() {
      _filtercheck = isChecked;
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    mapController.setMapStyle(value);
  }

  void _onMenuTap(BuildContext context) async {
    await SideSheet.left(
      context: context,
      //width: MediaQuery.of(context).size.width * 0.65,
      body: const DrawerScreen(),
      barrierDismissible: true,
      sheetBorderRadius: Sizes.size14,
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: Sizes.size52,
          padding: const EdgeInsets.only(
            left: Sizes.size12,
            right: Sizes.size6,
            top: Sizes.size3,
            bottom: Sizes.size3,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size10),
          ),
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _onMenuTap(context),
                child: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.78,
                child: TextField(
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Search places here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      size: Sizes.size28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          const Positioned(
            bottom: 110,
            right: 15,
            child: AddButton(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.size18),
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  itemCount: 10,
                  separatorBuilder: (context, index) => Gaps.h8,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return FilterChip(
                      selected: _filtercheck,
                      label: const Text("golf"),
                      avatar: const FaIcon(
                        FontAwesomeIcons.golfBallTee,
                        size: Sizes.size18,
                      ),
                      onSelected: (value) => _onChipTap(value),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
