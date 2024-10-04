class TaskStatus {
  final int id;
  final String name;

  TaskStatus({required this.id, required this.name});

  factory TaskStatus.fromJson(Map<String, dynamic> json) {
    return TaskStatus(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Task {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final int? assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.assignedTo,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.fromJson(json['status']),
      assignedTo: json['assigned_to'], // Adjust based on your API response
    );
  }
}
