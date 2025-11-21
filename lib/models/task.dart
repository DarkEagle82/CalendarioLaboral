class Task {
  final String id;
  final String title;
  bool isDone;
  final DateTime creationDate;

  Task({required this.id, required this.title, this.isDone = false, required this.creationDate});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'creationDate': creationDate.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        isDone: json['isDone'],
        creationDate: DateTime.parse(json['creationDate']),
      );
}
