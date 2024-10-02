import 'package:flutter/material.dart';
import 'package:task_management_app/services/api_service.dart';
import 'package:task_management_app/models/task.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TaskApiService _taskApiService = TaskApiService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> tasks = await _taskApiService.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching tasks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks')),
      );
    }
  }

  void _assignTask(Task task) {
    // Logic for assigning the task to a user can be implemented here
    // You can show a dialog or navigate to another screen for assigning
    print('Assigning task: ${task.title}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
          ? Center(child: Text('No tasks available'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          Task task = _tasks[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Assign') {
                    _assignTask(task);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Assign', 'Delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
