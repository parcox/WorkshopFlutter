class Task {
  // Properties
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;

  // Constructor
  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
  });

  // Convert dari JSON (Map) ke Task object - for SharedPreferences
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Convert dari Task object ke JSON (Map) - for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert dari Supabase response ke Task object
  // Note: Supabase uses snake_case for column names
  factory Task.fromSupabaseJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isCompleted: json['is_completed'] as bool? ?? false,  // snake_case dari database
      createdAt: DateTime.parse(json['created_at'] as String),  // snake_case
    );
  }

  // Convert Task object ke Supabase format (snake_case)
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,  // Convert ke snake_case untuk database
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper method untuk copy dengan perubahan
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Override toString untuk debugging
  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
