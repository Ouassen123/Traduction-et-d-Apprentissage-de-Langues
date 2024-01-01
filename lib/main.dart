import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:traduction_aprentissage_langues/login/login_ecran.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:traduction_aprentissage_langues/firebase_options.dart';
import 'package:traduction_aprentissage_langues/screens/chat/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  runApp(MaterialApp(
    home: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginEcran(),
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.chat),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        curve: Curves.easeIn,
        children: [
          SpeedDialChild(
            child: Icon(Icons.message),
            backgroundColor: Colors.green,
            label: 'Ouvrir le Chatbot',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatbotScreen(onClose: () {
                    // Logique pour fermer le chatbot
                    print('Fermer le chatbot');
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
