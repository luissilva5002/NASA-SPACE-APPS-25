// shark_details_page.dart
import 'package:flutter/material.dart';

class SharkDetailsPage extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String description;

  const SharkDetailsPage({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
