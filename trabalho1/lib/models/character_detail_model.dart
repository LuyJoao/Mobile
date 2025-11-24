class CrewDetail {
  final String name;
  final String romanName;
  final String totalBounty;
  final String isYonko;

  CrewDetail({
    required this.name,
    required this.romanName,
    required this.totalBounty,
    required this.isYonko,
  });

  factory CrewDetail.fromJson(Map<String, dynamic> json) {
    final isYonkoValue = json['is_yonko'];
    String isYonkoString = 'N/A';
    if (isYonkoValue is bool) {
      isYonkoString = isYonkoValue ? 'Sim' : 'Não';
    } else if (isYonkoValue != null) {
      isYonkoString = isYonkoValue.toString();
    }

    return CrewDetail(
      name: json['name'] ?? 'N/A',
      romanName: json['roman_name'] ?? 'N/A',
      totalBounty: json['total_prime']?.toString() ?? 'N/A',
      isYonko: isYonkoString,
    );
  }
}

class FruitDetail {
  final String name;
  final String type;
  final String description;

  FruitDetail({
    required this.name,
    required this.type,
    required this.description,
  });

  factory FruitDetail.fromJson(Map<String, dynamic> json) {
    return FruitDetail(
      name: json['name'] ?? 'N/A',
      type: json['type'] ?? 'N/A',
      description: json['description'] ?? 'Sem descrição.',
    );
  }
}

class CharacterDetail {
  final int id;
  final String name;
  final String job;
  final String bounty;
  final String status;
  final CrewDetail? crew;
  final FruitDetail? fruit;

  CharacterDetail({
    required this.id,
    required this.name,
    required this.job,
    required this.bounty,
    required this.status,
    this.crew,
    this.fruit,
  });

  factory CharacterDetail.fromJson(Map<String, dynamic> json) {
    final crewJson = json['crew'];
    final fruitJson = json['fruit'];
    final statusValue = json['status'];
    String statusString = 'N/A';
    if (statusValue is bool) {
      statusString = statusValue ? 'Vivo' : 'Morto';
    } else if (statusValue != null) {
      statusString = statusValue.toString();
    }

    return CharacterDetail(
      id: json['id'] as int,
      name: json['name'] ?? 'N/A',
      job: json['job'] ?? 'N/A',
      bounty: json['bounty']?.toString() ?? 'N/A',
      status: statusString,
      crew: crewJson != null ? CrewDetail.fromJson(crewJson) : null,
      fruit: fruitJson != null ? FruitDetail.fromJson(fruitJson) : null,
    );
  }
}