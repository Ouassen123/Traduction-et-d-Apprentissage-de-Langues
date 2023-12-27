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
        backgroundColor: const Color.fromARGB(
            255, 149, 33, 243), // Couleur de fond de la barre d'applications
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
                  child: ListTile(
                    title: Text(lesson['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${lesson['content'] ?? ''}'),
                        Text('Niveau d\'écoute: ${lesson['level'] ?? ''}'),
                        Text(
                            'Titre de la leçon: ${lesson['lesson_title'] ?? ''}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
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
                                    lessonTitle: lesson['lesson_title'] ?? '',
                                    courseText: lesson['courseText'] ??
                                        '', // Update with the correct key
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
                    onTap: () {
                      if (lesson['pdf_link'] != null) {
                        _launchPDF(lesson['pdf_link'] ?? '');
                      } else if (lesson['youtube_link'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YoutubePlayerScreen(
                              youtubeLink: lesson['youtube_link'] ?? '',
                              lessonDescription: lesson['description'] ?? '',
                              lessonTitle: lesson['lesson_title'] ?? '',
                              courseText: lesson['courseText'] ??
                                  '', // Update with the correct key
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Aucun lien disponible pour cette leçon.'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Function to launch PDF with url_launcher
  void _launchPDF(String pdfLink) async {
    if (await canLaunch(pdfLink)) {
      await launch(pdfLink);
    } else {
      throw 'Could not launch $pdfLink';
    }
  }
}
