import 'package:flutter/material.dart';

class AnalysisPage extends StatelessWidget {
  final List<String> questions;
  final List<List<String>> options;
  final List<int> correctOptionIndexes;
  final List<int> selectedOptionIndexes;

  const AnalysisPage({
    super.key,
    required this.questions,
    required this.options,
    required this.correctOptionIndexes,
    required this.selectedOptionIndexes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Page'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          String question = questions[index];
          List<String> questionOptions = options[index];
          int correctOptionIndex = correctOptionIndexes[index];
          int selectedOptionIndex = selectedOptionIndexes[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${index + 1}:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(question),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: questionOptions.length,
                    itemBuilder: (context, optionIndex) {
                      String option = questionOptions[optionIndex];
                      return ListTile(
                        leading: Icon(
                          optionIndex == correctOptionIndex
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: optionIndex == selectedOptionIndex
                              ? (optionIndex == correctOptionIndex
                                  ? Colors.green
                                  : Colors.red)
                              : Colors.grey,
                        ),
                        title: Text(option),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
