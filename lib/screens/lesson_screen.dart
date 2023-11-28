import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String language;

  LessonScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leçon de $language'),
      ),
      body: Center(
        child: Text('Contenu de la leçon ici'),
      ),
    );
  }
}
