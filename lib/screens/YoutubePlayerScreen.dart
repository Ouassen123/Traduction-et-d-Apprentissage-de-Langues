import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:traduction_aprentissage_langues/test/page_test.dart'; // Assurez-vous d'importer correctement votre fichier TestPage

class YoutubePlayerScreen extends StatefulWidget {
  final String youtubeLink;
  final String lessonDescription;
  final String lessonTitle;
  final String courseText;

  YoutubePlayerScreen({
    required this.youtubeLink,
    required this.lessonDescription,
    required this.lessonTitle,
    required this.courseText,
  });

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  int likes = 0;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Player'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId:
                    YoutubePlayer.convertUrlToId(widget.youtubeLink) ?? '',
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              progressColors: ProgressBarColors(
                playedColor: Colors.blueAccent,
                handleColor: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: isLiked ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      if (!isLiked) {
                        likes++;
                      } else {
                        likes--;
                      }
                      isLiked = !isLiked;
                    });
                  },
                ),
                Text('$likes Likes'),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.question_answer),
                  onPressed: () {
                    // Add logic for questions
                  },
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Add logic for sharing
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Titre de la leçon: ${widget.lessonTitle}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Contenu Continu de la leçon:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lessonTitle ?? 'No course text available',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.courseText ?? 'No course text available',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Nouveau bouton de test
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page de test
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestPage(),
                  ),
                );
              },
              child: Text(
                'Tester le cours',
                style: TextStyle(
                  color: Colors.white, // Couleur du texte
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 149, 33, 243),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
