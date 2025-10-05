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
      backgroundColor: const Color(0xFF1C3A5D),
      body: sharkSpecies.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top fact
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
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
          const SizedBox(height: 40),

          // Central message
          Text(
            'But what if we could change that?',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Sponsor or adopt section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Choose to sponsor our research or adopt a shark to directly fund us!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey[900],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),

          // Shark cards
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: sharkSpecies.length,
              itemBuilder: (context, index) {
                final species = sharkSpecies[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SharkCard(
                    name: species['name'],
                    imagePath: species['image'],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),

          // Adopt today banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Adopt today!',
              style: TextStyle(
                fontSize: 26,
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),

          // Info text
          Text(
            'When you sponsor our mission or adopt a shark, you’ll receive exclusive updates on your shark’s location, foraging behavior, and diet.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
