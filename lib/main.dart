import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/home_screen.dart';
import 'package:traduction_aprentissage_langues/screens/profil_screen.dart';
import 'package:traduction_aprentissage_langues/screens/favori_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Learning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
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
    // Add other screens as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Learning App'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Open the drawer when the menu icon is tapped
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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
          // Add more items as needed
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Accueil'),
              onTap: () {
                // Navigate to the home screen when the drawer item is tapped
                Navigator.pop(context); // Close the drawer
                setState(() {
                  _currentIndex = 0; // Change the active screen index
                });
              },
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {
                // Navigate to the profil screen when the drawer item is tapped
                Navigator.pop(context); // Close the drawer
                setState(() {
                  _currentIndex = 1; // Change the active screen index
                });
              },
            ),
            ListTile(
              title: Text('Favori'),
              onTap: () {
                // Navigate to the favori screen when the drawer item is tapped
                Navigator.pop(context); // Close the drawer
                setState(() {
                  _currentIndex = 2; // Change the active screen index
                });
              },
            ),
            // Add more drawer items as needed
          ],
        ),
      ),
    );
  }
}
