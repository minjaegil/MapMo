import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapmo/constants/sizes.dart';
import 'package:mapmo/features/map/widgets/add_button.dart';
import 'package:mapmo/features/map/widgets/tag_chips.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

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

  void _onMenuTap(BuildContext context) async {
    await showModalSideSheet(
      context: context,
      body: const Scaffold(),
      barrierDismissible: true,
      withCloseControll: false,
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
        title: TextField(
          style: TextStyle(
            color: Colors.grey.withOpacity(0.5),
          ),
          controller: _textEditingController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            suffixIcon: const Icon(
              Icons.search,
              size: Sizes.size28,
            ),
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () => _onMenuTap(context),
              ),
            ),
          ),
        ),
      ),
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
            child: Padding(
              padding: const EdgeInsets.only(left: Sizes.size18),
              child: SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    TagChips(),
                    TagChips(),
                    TagChips(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
