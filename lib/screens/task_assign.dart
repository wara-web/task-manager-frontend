import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssignTaskScreen extends StatefulWidget {
  @override
  _AssignTaskScreenState createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assignedToController = TextEditingController();
  bool _isLoading = false;

  Future<void> _assignTask() async {
    setState(() {
      _isLoading = true;  // Show loading indicator
    });

    final response = await http.post(
      Uri.parse('http://192.168.163.26:8000/api/assign-task/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'assigned_to': _assignedToController.text,
      }),
    );

    setState(() {
      _isLoading = false;  // Hide loading indicator
    });

    if (response.statusCode == 201) {
      // Task assigned successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task assigned successfully!')),
      );
      _clearFields();  // Clear the text fields
    } else {
      // Error assigning task
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning task: ${response.body}')),
      );
    }
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
    _assignedToController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assign Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            TextField(
              controller: _assignedToController,
              decoration: InputDecoration(labelText: 'Assign to (User ID or Username)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _assignTask,
              child: _isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Assign Task'),
            ),
          ],
        ),
      ),
    );
  }
}
