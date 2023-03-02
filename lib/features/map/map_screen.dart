import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/map/widgets/add_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final TextEditingController _textEditingController =
      TextEditingController(text: "Search places");

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size14,
            vertical: Sizes.size10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.size16),
          ),
          child: TextField(
            style: TextStyle(
              color: Colors.grey.withOpacity(0.5),
            ),
            controller: _textEditingController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              suffixIcon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            ),
          ),
        ),
      ),
      //backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
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
            child: SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FilterChip(
                    label: const Text("hi"),
                    onSelected: (value) => () {},
                  ),
                  FilterChip(
                    label: const Text("hi"),
                    onSelected: (value) => () {},
                  ),
                  FilterChip(
                    label: const Text("hi"),
                    onSelected: (value) => () {},
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
