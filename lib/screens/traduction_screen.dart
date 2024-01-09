import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Translator {
  final http.Client client;

  Translator(this.client);

  Future<String> translate(
      String text, String sourceLang, String targetLang) async {
    final result = <String>[];
    final url = Uri.parse(
      'https://translate.googleapis.com/translate_a/single?client=gtx&sl=$sourceLang&tl=$targetLang&dt=t&q=${Uri.encodeQueryComponent(text)}',
    );

    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Translation failed');
    }

    final List<dynamic> data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      final List<dynamic> translations = data[0];

      for (final dynamic slice in translations) {
        for (final dynamic translatedText in slice) {
          result.add('$translatedText');
          break;
        }
      }

      return result.join('');
    } else {
      throw Exception('Translation not found');
    }
  }
}

class TraductionScreen extends StatefulWidget {
  @override
  _TraductionScreenState createState() => _TraductionScreenState();
}

class _TraductionScreenState extends State<TraductionScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _selectedInputLanguage = 'en';
  String _selectedOutputLanguage = 'fr';
  String _result = '';

  final Translator _translator = Translator(http.Client());

  Future<void> _translateText() async {
    String textToTranslate = _textEditingController.text;

    try {
      String translatedText = await _translator.translate(
        textToTranslate,
        _selectedInputLanguage,
        _selectedOutputLanguage,
      );

      setState(() {
        _result = translatedText;
      });
    } catch (e) {
      print('Translation failed. Error: $e');
    }
  }

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
                border: OutlineInputBorder(),
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
                    items: ['en', 'fr', 'ar']
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
                    items: ['en', 'fr', 'ar']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _translateText,
                  child: Icon(Icons.translate),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Résultat : $_result',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
