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
  Map<String, Set<int>> selectedOptions = {};
  Color resultColor = Colors.red;

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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quiz['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            for (var questionKey
                in (quiz['questions'] as Map<String, dynamic>).keys)
              buildQuestion(quiz['questions'][questionKey], questionKey),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showResultDialog(quiz);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                primary: const Color.fromARGB(255, 145, 33, 243),
              ),
              child: Text('Valider', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(Map<String, dynamic> questionData, String questionKey) {
    question = questionData;
    if (!selectedOptions.containsKey(questionKey)) {
      selectedOptions[questionKey] = {};
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            question['questionText'] ?? 'No Question Text',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),
        for (var optionIndex = 0;
            optionIndex < (question['options'] as List<dynamic>).length;
            optionIndex++)
          buildOption(
            (question['options'] as List<dynamic>)[optionIndex],
            question['correctAnswerIndex'],
            questionKey,
            optionIndex,
          ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildOption(String option, int correctAnswerIndex, String questionKey,
      int optionIndex) {
    bool isOptionSelected = selectedOptions[questionKey]!.contains(optionIndex);
    bool isCorrectAnswer = optionIndex == correctAnswerIndex;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: isOptionSelected
            ? null
            : () {
                handleOptionSelection(
                    optionIndex, questionKey, correctAnswerIndex);
              },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(16),
          primary: isOptionSelected
              ? isCorrectAnswer
                  ? Colors.green
                  : Colors.red
              : Colors.blue,
        ),
        child: Text(option, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget buildCircularChart(int correctPercentage, int incorrectPercentage) {
    return SfCircularChart(
      title: ChartTitle(text: '$correctPercentage%'),
      series: <CircularSeries>[
        DoughnutSeries<int, String>(
          dataSource: <int>[correctPercentage, incorrectPercentage],
          xValueMapper: (int data, _) => '1',
          yValueMapper: (int data, _) => data,
          pointColorMapper: (int data, _) {
            return data == correctPercentage ? Colors.green : Colors.red;
          },
          innerRadius: '60%',
          explode: true,
          explodeIndex: 0,
          dataLabelSettings: DataLabelSettings(isVisible: false),
        ),
      ],
    );
  }

  void showResultDialog(Map<String, dynamic> quiz) {
    int totalQuestions = quiz['questions'].length;
    int correctPercentage =
        ((userScore / (totalQuestions * 50) / 2 * 100).toInt()).clamp(0, 100);
    int incorrectPercentage = 100 - correctPercentage;

    Color chartColor = correctPercentage == 100 ? Colors.green : Colors.red;

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
              buildCircularChart(correctPercentage, incorrectPercentage),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
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

  void handleOptionSelection(
      int optionIndex, String questionKey, int correctAnswerIndex) {
    print('Selected option index: $optionIndex');
    setState(() {
      selectedOptions[questionKey]!.clear();
      selectedOptions[questionKey]!.add(optionIndex);

      if (optionIndex == correctAnswerIndex) {
        userScore += 50;
        resultColor = Colors.green;
      } else {
        resultColor = Colors.red;
      }

      if (userScore > 100) {
        userScore = 100;
      }
    });
  }
}
