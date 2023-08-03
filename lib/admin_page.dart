import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers = [];
  int correctOptionIndex = 0;

  //initialize hive box
  final _mcqBox = Hive.box('McqDatabase');

  void _addOption() {
    setState(() {
      optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    setState(() {
      optionControllers.removeAt(index);
    });
  }

  void _addQuestion() {
    String question = questionController.text.trim();
    List<String> options =
        optionControllers.map((controller) => controller.text.trim()).toList();

    if (question.isNotEmpty && options.isNotEmpty) {
      if (correctOptionIndex >= 0 && correctOptionIndex < options.length) {
        Map<String, dynamic> mcqQuestion = {
          'question': question,
          'options': options,
          'correctOptionIndex': correctOptionIndex,
        };

        // Convert the LinkedHashMap to Map<String, dynamic> manually
        var mcqQuestionAsMap = Map<String, dynamic>.from(mcqQuestion);

        // Add the question to the Hive database
        _mcqBox.add(mcqQuestionAsMap);

        // Print the contents of the Hive database
        print('Hive Database Contents:');
        for (var i = 0; i < _mcqBox.length; i++) {
          var item = _mcqBox.getAt(i);
          print(item);
        }

        // Reset the text fields after adding the question
        questionController.clear();
        optionControllers.forEach((controller) => controller.clear());
        correctOptionIndex = 0;
      } else {
        _showSnackbar('Please select a valid correct option.');
      }
    } else {
      _showSnackbar('Please enter the question and at least one option.');
    }
  }

  void _deleteQuestion(int index) {
    _mcqBox.deleteAt(index);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: optionControllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: optionControllers[index],
                        decoration:
                            InputDecoration(labelText: 'Option ${index + 1}'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeOption(index),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addOption,
              child: Text('Add Option'),
            ),
            SizedBox(height: 16),
            DropdownButton<int>(
              value: correctOptionIndex,
              onChanged: (index) => setState(() => correctOptionIndex = index!),
              items: optionControllers.asMap().entries.map((entry) {
                int index = entry.key;
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text('Correct Option ${index + 1}'),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Add Question'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _mcqBox.listenable(),
                builder: (context, box, _) {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final mcqQuestion = box.getAt(index);
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Question ${index + 1}:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(mcqQuestion?['question']),
                              SizedBox(height: 8),
                              ...mcqQuestion?['options'].map<Widget>((option) {
                                int optionIndex =
                                    mcqQuestion?['options'].indexOf(option);
                                return ListTile(
                                  leading: Radio(
                                    value: optionIndex,
                                    groupValue:
                                        mcqQuestion?['correctOptionIndex'],
                                    onChanged: (_) {},
                                  ),
                                  title: Text(option),
                                );
                              }).toList(),
                              ElevatedButton(
                                onPressed: () => _deleteQuestion(index),
                                child: Text('Delete Question'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
