class Holiday {
  final int id;
  final String name;
  final DateTime date;

  Holiday({required this.id, required this.name, required this.date});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
    );
  }
} 