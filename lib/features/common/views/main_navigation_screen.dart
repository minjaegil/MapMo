import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mapmo/features/list/list_screen.dart';
import 'package:mapmo/features/common/models/saved_maps.dart';

import 'package:mapmo/features/map/views/map_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const routeName = "mainNavigation";

  final String tab;

  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "listview",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SavedMaps mapsList = SavedMaps();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: MapScreen(
              savedMaps: mapsList,
            ),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: ListScreen(savedMaps: mapsList),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: _onTap,
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.map),
                label: "지도",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.list),
                label: "모아보기",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
