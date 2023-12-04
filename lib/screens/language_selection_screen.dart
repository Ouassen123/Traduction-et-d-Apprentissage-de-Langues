import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/courses_screen.dart';
import 'package:traduction_aprentissage_langues/screens/session_manager.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  SessionManager sessionManager = SessionManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez une Langue'),
      ),
      body: ListView(
        children: [
          buildLanguageTile('Anglais'),
          buildLanguageTile('Arabe'),
          buildLanguageTile('Francais'),
          // Add other languages with trailing icons as needed
        ],
      ),
    );
  }

  Widget buildLanguageTile(String language) {
    return ListTile(
      title: Text(language),
      trailing: IconButton(
        icon: Icon(
          sessionManager.favoriteLanguages.contains(language)
              ? Icons.star
              : Icons.star_border,
        ),
        onPressed: () {
          sessionManager.toggleFavorite(language);
          setState(() {});
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoursesScreen(language: language),
          ),
        );
      },
    );
  }
}
