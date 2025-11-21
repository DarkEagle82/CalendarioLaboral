class Holiday {
  final String name;
  final DateTime date;
  final String type; // 'festivo', 'vacaciones', 'intensiva'

  Holiday({required this.name, required this.date, required this.type});

  // Método para convertir la instancia a un mapa JSON
  Map<String, dynamic> toJson() => {
    'name': name,
    'date': date.toIso8601String(),
    'type': type,
  };

  // Constructor factory para crear una instancia desde un mapa JSON
  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
    name: json['name'],
    date: DateTime.parse(json['date']),
    type: json['type'],
  );

  @override
  String toString() => name;
}
