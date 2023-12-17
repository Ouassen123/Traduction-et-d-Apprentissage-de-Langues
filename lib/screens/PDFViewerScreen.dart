import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfLink;
  final String lessonDescription;

  PdfViewerScreen({
    required this.pdfLink,
    required this.lessonDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PDFView(
              filePath: pdfLink,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageSnap: true,
              pageFling: true,
              onRender: (pages) {
                // Callback lors du rendu du PDF
              },
              onError: (error) {
                // Gérer les erreurs de chargement du PDF
              },
              onPageError: (page, error) {
                // Gérer les erreurs spécifiques à la page
              },
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              lessonDescription ?? 'No description available',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
