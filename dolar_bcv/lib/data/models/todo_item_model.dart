class TodoItemModel {
  final int? id;
  final String text;
  final bool isDone;

  TodoItemModel({
    this.id,
    required this.text,
    this.isDone = false,
  });

  factory TodoItemModel.fromMap(Map<String, dynamic> map) {
    return TodoItemModel(
      id: map['id'] as int?,
      text: map['text'] as String,
      isDone: (map['isDone'] as int) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'text': text,
      'isDone': isDone ? 1 : 0, // SQLite doesn't have boolean, maps to 0 / 1
    };
  }
}
