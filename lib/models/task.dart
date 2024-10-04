class Task {
  final int id; // Ensure this matches your Django model
  final String title;
  final String description;
  late final String status; // This field should be used to check task completion
  final String? assignedTo; // Change to 'int?' since your API returns an integer
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status, // This field should be used to check task completion
    this.assignedTo, // Nullable for optional assignment
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '', // Provide a default empty string if null
      status: json['status'] ?? 'pending', // Default status to 'pending' if null
      assignedTo: json['assigned_to'], // Change to 'int?' to match the API data type
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a Task object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'assigned_to': assignedTo, // Ensure it returns the correct type
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
