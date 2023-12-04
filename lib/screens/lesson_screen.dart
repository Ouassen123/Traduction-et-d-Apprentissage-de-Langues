import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonScreen extends StatelessWidget {
  final String language;

  LessonScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leçon de $language'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('lessons')
            .doc(language)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Vérifiez si le document existe
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No lessons available for $language'));
          }

          var lessonsData = snapshot.data!.data() as Map<String, dynamic>;
          // Utilisez la null-aware operator pour traiter le cas où 'lessons' est null
          var lessons = lessonsData['lessons'] as List<dynamic>? ?? [];

          return lessons.isEmpty
              ? Center(child: Text('No lessons available for $language'))
              : ListView.builder(
                  itemCount: lessons.length,
                  itemBuilder: (context, index) {
                    var lesson = lessons[index];
                    return ListTile(
                      title: Text(lesson['title'] ?? ''),
                      subtitle: Text(lesson['content'] ?? ''),
                    );
                  },
                );
        },
      ),
    );
  }
}
