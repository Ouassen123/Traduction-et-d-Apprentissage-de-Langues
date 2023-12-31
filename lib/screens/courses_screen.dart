import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:traduction_aprentissage_langues/screens/YoutubePlayerScreen.dart';

class CoursesScreen extends StatelessWidget {
  final String language;

  CoursesScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cours de $language'),
        backgroundColor: const Color.fromARGB(255, 149, 33, 243),
      ),
      body: FutureBuilder<DocumentSnapshot>(
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
                final lesson = lessons[index];

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          lesson['title'] ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description: ${lesson['content'] ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Niveau d\'écoute: ${lesson['level'] ?? ''}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Titre de la leçon: ${lesson['lesson_title'] ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (lesson['pdf_link'] != null) {
                                _launchPDF(lesson['pdf_link'] ?? '');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            child: Text('Ouvrir PDF'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (lesson['youtube_link'] != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YoutubePlayerScreen(
                                      youtubeLink: lesson['youtube_link'] ?? '',
                                      lessonDescription:
                                          lesson['description'] ?? '',
                                      lessonTitle: lesson['title'] ?? '',
                                      courseText: lesson['courseText'] ?? '',
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                            ),
                            child: Text('Voir Vidéo'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Fonction pour ouvrir le PDF avec url_launcher
  void _launchPDF(String pdfLink) async {
    if (await canLaunch(pdfLink)) {
      await launch(pdfLink);
    } else {
      throw 'Could not launch $pdfLink';
    }
  }
}
