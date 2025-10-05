import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'menu.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  List<String> userPhotos = [];
  bool isLoading = true;

  String name = 'unknown';
  String bio = 'No Bio...';
  String email = 'unknown';
  String creationDate = '${DateTime.now()}';

  User? currentUser;

  List<Map<String, dynamic>> userAnimals = [];

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
  }

  Future<void> _initializeProfileData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _loadUserInfo(),
    ]);
    setState(() => isLoading = false);
  }


  Future<void> _loadUserInfo() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    setState(() {
      isLoading = true;
    });

    DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

    if (userInfo.exists) {
        setState(() {
          name = userInfo['display_name'] ?? 'User123';
          bio = userInfo['bio'] ?? 'No Bio...';
          email = userInfo['email'] ?? 'john.doe@gmail.com';
          creationDate = userInfo['created_time'] ?? '${DateTime.now()}';
        });
    }

    setState(() {
      isLoading = false;
    });
  }


  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : const AssetImage('assets/images/default_profile.png') as ImageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color:  Theme.of(context).colorScheme.primary,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(child: _buildAvatar()),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                bio,
                style: TextStyle(fontSize: 14, color:  Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(thickness: 2, height: 2, color: Theme.of(context).colorScheme.tertiary),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 300,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color:  Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.add, size: 40, color:  Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    // Then display the photos (if any)
                    ...userPhotos.map((url) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}