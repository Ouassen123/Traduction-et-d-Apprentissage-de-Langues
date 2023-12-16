import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:traduction_aprentissage_langues/screens/LessonScreen.dart';
import 'package:traduction_aprentissage_langues/screens/PDFViewerScreen.dart';

class CoursesScreen extends StatelessWidget {
  final String language;

  CoursesScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cours de $language'),
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
                Map<String, dynamic> lesson = lessons[index];
                return Card(
                  elevation: 2, // Ajustez l'élévation selon vos préférences
                  margin: EdgeInsets.all(
                      8), // Ajustez la marge selon vos préférences
                  child: ListTile(
                    title: Text(lesson['title'] ?? ''),
                    subtitle: Text(lesson['content'] ?? ''),
                    onTap: () {
                      if (lesson['pdf_link'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFViewerScreen(
                              pdfLink: lesson['pdf_link'],
                            ),
                          ),
                        );
                      } else if (lesson['youtube_link'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => YoutubePlayerScreen(
                              youtubeLink: lesson['youtube_link'],
                            ),
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
}

class YoutubePlayerScreen extends StatefulWidget {
  final String youtubeLink;

  YoutubePlayerScreen({required this.youtubeLink});

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeLink) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            progressColors: ProgressBarColors(
              playedColor: Colors.blueAccent,
              handleColor: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Description:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Description de la leçon ici...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
