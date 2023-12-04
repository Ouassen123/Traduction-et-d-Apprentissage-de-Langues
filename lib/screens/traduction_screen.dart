import 'package:flutter/material.dart';
import 'package:traduction_aprentissage_langues/screens/courses_screen.dart';

class TraductionScreen extends StatefulWidget {
  @override
  _TraductionScreenState createState() => _TraductionScreenState();
}

class _TraductionScreenState extends State<TraductionScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _selectedInputLanguage = 'Anglais';
  String _selectedOutputLanguage = 'Français';
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Traduction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Saisissez le texte',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedInputLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedInputLanguage = newValue!;
                      });
                    },
                    items: ['Anglais', 'Français', 'Arabe'] 
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 16.0),
                Icon(Icons.compare_arrows, size: 32.0), 
                SizedBox(width: 16.0),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedOutputLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOutputLanguage = newValue!;
                      });
                    },
                    items: ['Anglais', 'Français', 'Arabe'] 
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(Icons.translate),
                  onPressed: () {
 
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Résultat : $_result',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
