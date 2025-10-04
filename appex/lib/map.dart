import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HeatMapPage extends StatelessWidget {
  final List<LatLng> hotspots = [
    LatLng(40.7128, -74.0060),
    LatLng(34.0522, -118.2437),
    LatLng(51.5074, -0.1278),
  ];

  HeatMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Heat Zones Map')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(40.7128, -74.0060),
          initialZoom: 10,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all, // enables pan, pinch, scroll, double-tap, etc.
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.yourcompany.yourapp',
          ),
          MarkerLayer(
            markers: hotspots
                .map(
                  (point) => Marker(
                point: point,
                width: 40,
                height: 40,
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            )
                .toList(),
          ),
          CircleLayer(
            circles: hotspots
                .map(
                  (point) => CircleMarker(
                point: point,
                radius: 50,
                color: Colors.red.withOpacity(0.4),
                borderStrokeWidth: 2,
                borderColor: Colors.red,
              ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
