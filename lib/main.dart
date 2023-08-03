import 'package:adsgroo_task1/user_page.dart';
import 'package:adsgroo_task1/util/mcq_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'admin_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('McqDatabase');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminPage()));
                },
                child: Text('Login as admin')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserPage()));
                },
                child: Text('Login as User'))
          ],
        ),
      ),
    );
  }
}


// List<McqModel> sampleQuestions = [
//   McqModel(
//     question: "What is the capital of India?",
//     options: ["Maharashtra", "Delhi", "Goa", "Gujarat"],
//     correctOptionIndex: 1,
//   ),
//   McqModel(
//     question: "Which Country won the 23' FIFA WC?",
//     options: ["France", "Portugal", "Argentina", "India"],
//     correctOptionIndex: 2,
//   ),
//   McqModel(
//     question: "Black hole is: ",
//     options: [
//       "A dark hollow cavity",
//       "A massive collapsing star",
//       "The other side on the moon",
//       "The other side of sun"
//     ],
//     correctOptionIndex: 1,
//   ),
// ];
