import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/lesson_screen.dart';

class CoursesScreen extends StatelessWidget {
  final String language;

  CoursesScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cours de $language'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LessonScreen(language: language)),
            );
          },
          child: Text('Commencer le Cours'),
        ),
      ),
    );
  }
}
