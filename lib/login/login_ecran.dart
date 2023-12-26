import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/home_screen.dart';

class LoginEcran extends StatelessWidget {
  const LoginEcran({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen();
        }
        return ProfileScreen(
          children: [
            Text("Email: ${snapshot.data!.email}"),
            Text("Nom: ${snapshot.data!.displayName ?? ''}"),
            ElevatedButton(
              onPressed: () {
                // Navigate to HomeScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text("Go to HomeScreen"),
            ),
          ],
        );
      },
    );
  }
}
