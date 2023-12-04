import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add profile information widgets here
          Text('User Name'),
          Text('Email@example.com'),
          // Add other details as needed
        ],
      ),
    );
  }
}
