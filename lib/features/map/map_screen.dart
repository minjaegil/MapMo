import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmo/constants/gaps.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/drawer/drawer_screen.dart';
import 'package:mapmo/features/map/widgets/add_button.dart';
import 'package:mapmo/features/map/widgets/tag_model.dart';

import 'package:side_sheet/side_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final TextEditingController _textEditingController = TextEditingController();

  final LatLng _center = const LatLng(45.521563, -122.677433);

  final List<TagModel> _chipsList = [
    TagModel("Android", Colors.green, false),
    TagModel("Flutter", Colors.blueGrey, false),
    TagModel("Ios", Colors.deepOrange, false),
    TagModel("Python", Colors.cyan, false),
    TagModel("React JS", Colors.teal, false),
  ];

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _mapController.setMapStyle(value);
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
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            top: Sizes.size5,
            bottom: Sizes.size5,
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
                  itemCount: _chipsList.length,
                  separatorBuilder: (context, index) => Gaps.h7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return FilterChip(
                      elevation: 1,
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      selectedColor: _chipsList[index].color.withOpacity(0.9),
                      selected: _chipsList[index].isSelected,
                      label: Text(_chipsList[index].label),
                      side: BorderSide(color: _chipsList[index].color),
                      onSelected: (value) => setState(() {
                        _chipsList[index].isSelected = value;
                      }),
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
