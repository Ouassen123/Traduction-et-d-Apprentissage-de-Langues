import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center the profile picture horizontally
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
                child: user?.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 50,
                      )
                    : null,
              ),
            ),
            SizedBox(height: 20),

            // Display user profile information
            Text(
              'Email: ${user?.email ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Nom: ${user?.displayName ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            // You can add more details as needed
          ],
        ),
      ),
    );
  }
}
