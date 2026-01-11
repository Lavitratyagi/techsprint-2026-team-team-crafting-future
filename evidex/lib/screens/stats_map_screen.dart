import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class StatsMapScreen extends StatefulWidget {
  const StatsMapScreen({super.key});

  @override
  State<StatsMapScreen> createState() => _StatsMapScreenState();
}

class _StatsMapScreenState extends State<StatsMapScreen> {
  final MapController _mapController = MapController();

  String? selectedCountry;
  String? selectedState;

  /// COUNTRY CENTER (used only for initial country zoom)
  final Map<String, LatLng> countryCenters = {
    "India": LatLng(20.5937, 78.9629),
    "USA": LatLng(37.0902, -95.7129),
  };

  /// ✅ STATE BOUNDS (CORRECT FIX)
  final Map<String, Map<String, LatLngBounds>> stateBounds = {
    "India": {
      "Delhi": LatLngBounds(
        LatLng(28.4040, 76.8380), // South-West
        LatLng(28.8830, 77.3470), // North-East
      ),
      "Maharashtra": LatLngBounds(
        LatLng(15.6024, 72.6594),
        LatLng(22.0268, 80.8900),
      ),
    },
    "USA": {
      "California": LatLngBounds(
        LatLng(32.5121, -124.6509),
        LatLng(42.0126, -114.1315),
      ),
      "Texas": LatLngBounds(
        LatLng(25.8371, -106.6456),
        LatLng(36.5007, -93.5080),
      ),
    },
  };

  void _moveToCountry(String country) {
    _mapController.move(
      countryCenters[country]!,
      4,
    );
  }

  void _fitToState(String country, String state) {
    final bounds = stateBounds[country]![state]!;

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌍 MAP
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(20, 0),
              initialZoom: 2,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.evidex.app',
                tileProvider: NetworkTileProvider(), // avoids cache crash
              ),
            ],
          ),

          /// 🔍 SEARCH CONTROLS
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _searchDropdown(
                    hint: "Search for your country",
                    value: selectedCountry,
                    items: countryCenters.keys.toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value;
                        selectedState = null;
                      });
                      _moveToCountry(value);
                    },
                  ),

                  const SizedBox(height: 12),

                  _searchDropdown(
                    hint: "Search for your state",
                    value: selectedState,
                    items: selectedCountry == null
                        ? []
                        : stateBounds[selectedCountry!]!
                            .keys
                            .toList(),
                    onChanged: (value) {
                      setState(() => selectedState = value);
                      _fitToState(selectedCountry!, value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 SEARCH STYLE DROPDOWN
  Widget _searchDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            children: [
              const Icon(Icons.search, size: 20),
              const SizedBox(width: 8),
              Text(hint),
            ],
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: items.isEmpty ? null : (v) => onChanged(v!),
        ),
      ),
    );
  }
}
