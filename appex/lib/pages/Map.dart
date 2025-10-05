import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'DetailPage.dart';

class HeatMapPage extends StatefulWidget {
  const HeatMapPage({super.key});

  @override
  State<HeatMapPage> createState() => _HeatMapPageState();
}

class _HeatMapPageState extends State<HeatMapPage> {
  final List<LatLng> hotspots = [
    LatLng(40.7128, -74.0060),
    LatLng(34.0522, -118.2437),
    LatLng(51.5074, -0.1278),
  ];

  List<Map<String, dynamic>> sharkSpecies = [];
  List<Map<String, dynamic>> sharkNews = [];

  // 🔑 NEW: For search
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final speciesData =
    jsonDecode(await rootBundle.loadString('assets/sharks.json'));
    final newsData =
    jsonDecode(await rootBundle.loadString('assets/news.json'));

    setState(() {
      sharkSpecies = List<Map<String, dynamic>>.from(speciesData);
      sharkNews = List<Map<String, dynamic>>.from(newsData);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔑 Apply filtering here
    final filteredSpecies = sharkSpecies.where((species) {
      final name = species['name'].toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    final filteredNews = sharkNews.where((news) {
      final title = news['title'].toString().toLowerCase();
      final summary = news['summary'].toString().toLowerCase();
      return title.contains(searchQuery.toLowerCase()) ||
          summary.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          // MAP
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(40.7128, -74.0060),
              initialZoom: 10,
              minZoom: 3,
              maxZoom: 18,
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds.fromPoints([
                  LatLng(-85, -180),
                  LatLng(85, 180),
                ]),
              ),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.doubleTapZoom,
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
                    child: const Icon(
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


          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(30),
              child: Column(
                mainAxisSize: MainAxisSize.min, // adapt height
                children: [
                  // Search TextField (normal padding to stay vertically centered)
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search sharks...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14, // keep vertical padding for vertical centering
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchQuery = "";
                          });
                        },
                      )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),

                  // Suggestions (integrated smoothly)
                  if (searchQuery.isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      child: Container(
                        color: Colors.white,
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: sharkSpecies
                              .where((species) => species['name']
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                              .map((species) => ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                species['image'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(species['name']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SharkDetailsPage(
                                    name: species['name'],
                                    imageUrl: species['image'],
                                    description: species['description'] ??
                                        "No description available.",
                                  ),
                                ),
                              );
                            },
                          ))
                              .toList(),
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(), // no suggestions, no extra space
                ],
              ),
            ),
          ),

          // DRAGGABLE CONTAINER
          DraggableScrollableSheet(
            initialChildSize: 0.15,
            minChildSize: 0.1,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Grab handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "🦈 Shark Species",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Shark species horizontal list (filtered)
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredSpecies.length,
                        itemBuilder: (context, index) {
                          final species = filteredSpecies[index];
                          return sharkSpeciesCard(
                              species['name'], species['image']);
                        },
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "🦈 Shark News",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // News cards (filtered)
                    ...filteredNews.map((news) => sharkNewsCard(
                      news['title'],
                      news['summary'],
                      news['image'],
                    )),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper widget for shark species (horizontal scroll)
  Widget sharkSpeciesCard(String name, String imageUrl) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              height: 100,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Helper widget for shark news (vertical list)
  Widget sharkNewsCard(String title, String summary, String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  summary,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}