import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiService {
  // Change this to your local IP or production URL if necessary
  final String baseUrl = 'http://192.168.163.26:8000/api';

  // Fetch all tasks
  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks/'));
      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((task) => Task.fromJson(task)).toList();
      } else {
        print('Error fetching tasks: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load tasks due to an error');
    }
  }

  // Fetch a task by ID
  Future<Task> getTaskById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks/$id'));
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        print('Error fetching task by ID: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load task');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load task due to an error');
    }
  }

  // Create a new task
  Future<Task> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 201) {
        return Task.fromJson(json.decode(response.body));
      } else {
        print('Error creating task: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to create task');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to create task due to an error');
    }
  }

  // Update an existing task
  Future<Task> updateTask(int id, Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(task.toJson()),
      );
      if (response.statusCode == 200) {
        return Task.fromJson(json.decode(response.body));
      } else {
        print('Error updating task: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to update task');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update task due to an error');
    }
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
      if (response.statusCode == 204) {
        print('Task deleted successfully');
      } else {
        print('Error deleting task: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to delete task due to an error');
    }
  }
}
