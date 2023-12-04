import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/language_selection_screen.dart';
import 'package:traduction_aprentissage_langues/screens/traduction_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/LanguageLearning.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageSelectionScreen(),
                    ),
                  );
                },
                child: Text('Commencer'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TraductionScreen(),
                    ),
                  );
                },
                child: Text('Traduction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
