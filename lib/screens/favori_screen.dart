import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/session_manager.dart';

class FavoriScreen extends StatefulWidget {
  @override
  _FavoriScreenState createState() => _FavoriScreenState();
}

class _FavoriScreenState extends State<FavoriScreen> {
  SessionManager sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: ListView.builder(
        itemCount: sessionManager.favoriteLanguages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sessionManager.favoriteLanguages[index]),
            // Add other details if needed
          );
        },
      ),
    );
  }
}
