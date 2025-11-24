class Fruit {
  final int id;
  final String name;
  final String type;
  final String romanName;
  final String description; 

  Fruit({
    required this.id,
    required this.name,
    required this.type,
    required this.romanName,
    required this.description,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      id: json['id'] as int,
      name: json['name'] ?? 'N/A',
      type: json['type'] ?? 'N/A',
      romanName: json['roman_name'] ?? 'N/A',
      description: json['description'] ?? 'Sem descrição.', 
    );
  }
}