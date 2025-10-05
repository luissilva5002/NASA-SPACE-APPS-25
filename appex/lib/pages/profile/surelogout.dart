import 'package:appex/authentication/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SureLogout extends StatelessWidget {
  const SureLogout({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AuthPage()), // Replace LoginPage with your login screen widget
                  (route) => false,  // This condition ensures that all routes are removed
            );
          },
          child: const Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}