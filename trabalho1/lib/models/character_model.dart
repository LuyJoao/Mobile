class Character {
  final int id;
  final String name;
  final String job;
  final String size;
  final String birthday;
  final String age;
  final String bounty;
  final String status;

  Character({
    required this.id,
    required this.name,
    required this.job,
    required this.size,
    required this.birthday,
    required this.age,
    required this.bounty,
    required this.status,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      job: json['job'] ?? 'N/A',
      size: json['size'] ?? 'N/A',
      birthday: json['birthday'] ?? 'N/A',
      age: json['age'] ?? 'N/A',
      bounty: json['bounty'] ?? 'N/A',
      status: json['status'] ?? 'N/A',
    );
  }
}