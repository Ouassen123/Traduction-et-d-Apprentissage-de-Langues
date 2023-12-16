import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traduction_aprentissage_langues/screens/LessonScreen.dart';

class CoursesScreen extends StatelessWidget {
  final String language;

  CoursesScreen({required this.language});

  Future<bool> isFirebaseConnected() async {
    try {
      await FirebaseFirestore.instance.settings;
      await FirebaseFirestore.instance.collection('test').doc('test').get();
      return true;
    } catch (e) {
      print('Firebase connection error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cours de $language'),
      ),
      body: FutureBuilder<bool>(
        future: isFirebaseConnected(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.data!) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Firebase connection not available.'),
                  ElevatedButton(
                    onPressed: () {
                      // Retry connecting to Firebase
                      isFirebaseConnected();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            // Firebase connection successful, display your data
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('languages')
                  .doc(language)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.data!.exists) {
                  return Center(child: Text('Data not found.'));
                } else {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List<dynamic> lessons = data['lessons'];

                  return ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> lesson = lessons[index];
                      return ListTile(
                        title: Text(lesson['title'] ?? ''),
                        subtitle: Text(lesson['content'] ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonScreen(
                                language: language,
                                lessonTitle: lesson['title'] ?? '',
                                lessonContent: lesson['content'] ?? '',
                                pdfLink: lesson['pdf_link'] ?? '',
                                youtubeLink: lesson['youtube_link'] ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
