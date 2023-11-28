import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/courses_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisissez une Langue'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Anglais'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoursesScreen(language: 'Anglais')),
              );
            },
          ),
          // Ajoutez d'autres langues ici
        ],
      ),
    );
  }
}
