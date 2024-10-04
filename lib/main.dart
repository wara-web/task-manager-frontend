import 'package:flutter/material.dart';
import 'package:task_management_app/screens/login.dart'; // Import the login.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set a primary color theme for the app
      ),
      home: LoginScreen(), // Set the initial screen to LoginScreen
      debugShowCheckedModeBanner: false, // Optional: remove the debug banner
    );
  }
}
