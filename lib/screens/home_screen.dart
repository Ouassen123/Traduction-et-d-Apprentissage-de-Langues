import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traduction_aprentissage_langues/screens/language_selection_screen.dart';
import 'package:traduction_aprentissage_langues/screens/traduction_screen.dart';
import 'package:traduction_aprentissage_langues/screens/profil_screen.dart';
import 'package:traduction_aprentissage_langues/screens/favori_screen.dart';
import 'package:traduction_aprentissage_langues/screens/chat/chat.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/LanguageLearning.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
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
        ],
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfilScreen(),
    FavoriScreen(),
  ];

  final List<String> _appBarTitles = [
    'Accueil',
    'Profil',
    'Favori',
  ];

  Color _appBarBackgroundColor = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language Learning App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          SizedBox(width: 10),
        ],
        backgroundColor: _appBarBackgroundColor,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print("Tapped on index: $index");
          setState(() {
            _currentIndex = index;
            _updateAppBarColor();
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favori',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.chat),
        backgroundColor: Colors.purple,
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
              // Ajoutez une animation ici si nécessaire
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                FirebaseAuth.instance.currentUser?.displayName ?? '',
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? '',
                style: TextStyle(fontSize: 16),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    FirebaseAuth.instance.currentUser?.photoURL ?? ''),
              ),
            ),
            ListTile(
              title: Text(
                'Accueil',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                  _updateAppBarColor(); // Reset color when changing screen
                });
              },
            ),
            ListTile(
              title: Text(
                'Profil',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 1;
                  _updateAppBarColor(); // Reset color when changing screen
                });
              },
            ),
            ListTile(
              title: Text(
                'Favori',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 2;
                  _updateAppBarColor(); // Reset color when changing screen
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateAppBarColor() {
    setState(() {
      // Update color based on _currentIndex
      switch (_currentIndex) {
        case 0:
          _appBarBackgroundColor = Colors.purple;
          break;
        case 1:
          _appBarBackgroundColor = Colors.green;
          break;
        case 2:
          _appBarBackgroundColor = Colors.red;
          break;
        // Add more cases as needed
        default:
          _appBarBackgroundColor = Colors.purple;
      }
    });
  }
}
