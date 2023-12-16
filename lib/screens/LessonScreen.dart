import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String language;
  final String lessonTitle;
  final String lessonContent;
  final String pdfLink;
  final String youtubeLink;

  LessonScreen({
    required this.language,
    required this.lessonTitle,
    required this.lessonContent,
    required this.pdfLink,
    required this.youtubeLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson: $lessonTitle'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Language: $language',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Title: $lessonTitle',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Content: $lessonContent',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'PDF Link: $pdfLink',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'YouTube Link: $youtubeLink',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
