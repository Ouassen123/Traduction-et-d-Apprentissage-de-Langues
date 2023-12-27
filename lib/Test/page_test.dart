import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Future<Map<String, dynamic>> quizData;
  int userScore = 0;
  late Map<String, dynamic> question;

  @override
  void initState() {
    super.initState();
    quizData = fetchTestFromFirestore('test1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de Test'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: quizData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            Map<String, dynamic> quiz = snapshot.data!;
            return buildQuiz(quiz);
          }
        },
      ),
    );
  }

  Widget buildQuiz(Map<String, dynamic> quiz) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          quiz['title'] ?? 'No Title',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        for (var questionKey
            in (quiz['questions'] as Map<String, dynamic>).keys)
          buildQuestion(
            quiz['questions'][questionKey],
          ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showResultDialog();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            primary: Colors.green,
          ),
          child: Text('Valider', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  Widget buildQuestion(Map<String, dynamic> questionData) {
    question = questionData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          question['questionText'] ?? 'No Question Text',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        for (var option in (question['options'] as List<dynamic>))
          buildOption(option, question['correctAnswerIndex']),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildOption(String option, int correctAnswerIndex) {
    return ElevatedButton(
      onPressed: () {
        handleOptionSelection(option, correctAnswerIndex);
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(16),
        primary: Colors.blue,
      ),
      child: Text(option, style: TextStyle(fontSize: 16)),
    );
  }

  Widget buildCircularChart(int score) {
    return SfCircularChart(
      title: ChartTitle(text: '$score%'),
      series: <CircularSeries>[
        DoughnutSeries<int, String>(
          dataSource: <int>[score, 100 - score],
          xValueMapper: (int data, _) =>
              '1', // Use a constant x-value as a String
          yValueMapper: (int data, _) => data,
          pointColorMapper: (int data, _) {
            return data == score ? Colors.green : Colors.red;
          },
          innerRadius: '60%', // Adjust the inner radius as needed
          explode: true,
          explodeIndex: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false),
        ),
      ],
    );
  }

  void showResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Résultat du test'),
          content: Column(
            children: [
              Text(
                'Votre score est de $userScore points.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              buildCircularChart(userScore),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchTestFromFirestore(String testId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('tests')
          .doc(testId)
          .get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception('Test data not found');
      }
    } catch (e) {
      print('Error fetching test data: $e');
      throw Exception('Failed to fetch test data');
    }
  }

  void handleOptionSelection(String option, int correctAnswerIndex) {
    print('Selected: $option');
    if (option == (question['options'] as List<dynamic>)[correctAnswerIndex]) {
      setState(() {
        userScore += 10;
      });
    }
  }
}
