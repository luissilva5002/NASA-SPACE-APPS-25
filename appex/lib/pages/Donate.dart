import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharkAdoptionPage extends StatefulWidget {
  const SharkAdoptionPage({super.key});

  @override
  State<SharkAdoptionPage> createState() => _SharkAdoptionPageState();
}

class _SharkAdoptionPageState extends State<SharkAdoptionPage> {
  List<Map<String, dynamic>> sharkSpecies = [];

  @override
  void initState() {
    super.initState();
    loadSharkSpecies();
  }

  Future<void> loadSharkSpecies() async {
    final String response = await rootBundle.loadString('assets/sharks.json');
    final data = jsonDecode(response) as List<dynamic>;
    setState(() {
      sharkSpecies = data.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: sharkSpecies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top fact
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '1 in 3\nsharks species around the world is threatened with extinction.',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.blueGrey[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),

                // Central message
                Text(
                  'But what if we could change that?',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Sponsor or adopt section
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Choose to sponsor our research or adopt a shark to directly fund us!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),

                // Shark cards
                SizedBox(
                  height: 180, // adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sharkSpecies.length,
                    itemBuilder: (context, index) {
                      final species = sharkSpecies[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SharkCard(
                          name: species['name'],
                          imagePath: species['image'],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 30),

                // Adopt today banner
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Adopt today!',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blueGrey[900],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),

                // Info text
                Text(
                  'When you sponsor our mission or adopt a shark, you’ll receive exclusive updates on your shark’s location, foraging behavior, and diet',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SharkCard extends StatelessWidget {
  final String name;
  final String imagePath;

  const SharkCard({required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
