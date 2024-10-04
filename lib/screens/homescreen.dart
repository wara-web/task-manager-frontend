import 'package:flutter/material.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskApiService _taskApiService = TaskApiService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  bool _isSuperuser = false; // Change this based on the logged-in user

  @override
  void initState() {
    super.initState();
    _isSuperuser = true; // Set to true for testing, replace with your actual check
    _fetchTasks();  // Fetch tasks on initialization
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> tasks = await _taskApiService.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;  // Hide loading indicator
      });
    } catch (error) {
      print('Error fetching tasks: $error');
      setState(() {
        _isLoading = false;  // Hide loading indicator
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks')),
      );  // Notify user of the error
    }
  }

  Future<void> _toggleTaskStatus(Task task, String status) async {
    task.status = status; // Update local task status
    await _taskApiService.updateTask(task.id, task);
    _fetchTasks();
  }

  Future<void> _deleteTask(int taskId) async {
    await _taskApiService.deleteTask(taskId);
    _fetchTasks();
  }

  Future<void> _showCreateTaskDialog() async {
    String title = '';
    String description = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  title = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  description = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (title.isNotEmpty && description.isNotEmpty) {
                  Task newTask = Task(
                    id: 0,
                    title: title,
                    description: description,
                    status: 'pending',
                    assignedTo: null,
                    createdAt: DateTime.now(), // Set created date here
                    updatedAt: DateTime.now(),
                  );

                  await _taskApiService.createTask(newTask);
                  Navigator.of(context).pop(); // Close dialog
                  _fetchTasks(); // Refresh tasks
                }
              },
              child: Text('Create'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    // Implement your logout logic here
    Navigator.of(context).pushReplacementNamed('/login'); // Navigate to the login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          if (_isSuperuser)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showCreateTaskDialog, // Open dialog to create a new task
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
          ? Center(child: Text('No tasks available'))
          : SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Assigned To')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Created At')), // New column for created date
            DataColumn(label: Text('Actions')),
          ],
          rows: _tasks.map((task) {
            return DataRow(cells: [
              DataCell(Text(task.id.toString())),
              DataCell(Text(task.title)),
              DataCell(Text(task.assignedTo?.toString() ?? 'Unassigned')),
              DataCell(
                DropdownButton<String>(
                  value: task.status,
                  items: [
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'complete', child: Text('Complete')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _toggleTaskStatus(task, value);
                    }
                  },
                ),
              ),
              DataCell(Text(task.createdAt.toLocal().toString().split(' ')[0])), // Display formatted date
              DataCell(
                Row(
                  children: [
                    if (_isSuperuser)
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(task.id),
                      ),
                  ],
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
