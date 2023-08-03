import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'analysis_page.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _mcqBox = Hive.box('McqDatabase');

  List<int> _selectedOptions = [];

  void _onOptionSelected(int index, int optionIndex) {
    setState(() {
      _selectedOptions[index] = optionIndex;
    });
  }

  void _navigatorAnalysisPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnalysisPage(
          questions:
              _mcqBox.values.map((item) => item['question'] as String).toList(),
          options: _mcqBox.values
              .map((item) => (item['options'] as List<dynamic>)
                  .map((option) => option.toString())
                  .toList())
              .toList(),
          correctOptionIndexes: _mcqBox.values
              .map((item) => item['correctOptionIndex'] as int)
              .toList(),
          selectedOptionIndexes: _selectedOptions,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize the list to keep track of user-selected options
    _selectedOptions = List.generate(_mcqBox.length, (index) => -1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                                    mcqQuestion['options'].indexOf(option);
                                return ListTile(
                                  leading: Radio(
                                    value: optionIndex,
                                    groupValue: _selectedOptions[index],
                                    onChanged: (value) =>
                                        _onOptionSelected(index, value!),
                                  ),
                                  title: Text(option),
                                );
                              }).toList(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigatorAnalysisPage();
        },
        child: Icon(Icons.assessment),
      ),
    );
  }
}
