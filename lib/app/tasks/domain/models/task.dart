class Task {
  final int id;

  final String title;

  final String description;

  final bool isActive;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.isActive = true,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isActive,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant Task other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isActive.hashCode;
  }
}
