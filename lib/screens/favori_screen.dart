import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/session_manager.dart';
import 'package:traduction_aprentissage_langues/screens/courses_screen.dart';

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
            onTap: () {
              // Perform additional actions or treatments when tapping on a favorite language
              String selectedLanguage = sessionManager.favoriteLanguages[index];
              // Add your logic here

              // For example, you can navigate to a specific screen for the selected language
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CoursesScreen(language: selectedLanguage),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
