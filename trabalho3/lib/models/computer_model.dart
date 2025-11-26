import 'package:cloud_firestore/cloud_firestore.dart';

class Computer {
  final String? id;
  final String name;
  final String processor;
  final String ram;
  final String gpu;
  final String? powerSupply;
  final String? caseModel;
  final String? motherboard;
  final String operatingSystem;
  final String storageType;
  final int ssdCount;
  final int hdCount;
  final String? imagePath;
  final bool isComplete;
  final String? userId;

  Computer({
    this.id,
    required this.name,
    required this.processor,
    required this.ram,
    required this.gpu,
    this.powerSupply,
    this.caseModel,
    this.motherboard,
    required this.operatingSystem,
    required this.storageType,
    required this.ssdCount,
    required this.hdCount,
    this.imagePath,
    required this.isComplete,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'processor': processor,
      'ram': ram,
      'gpu': gpu,
      'powerSupply': powerSupply,
      'caseModel': caseModel,
      'motherboard': motherboard,
      'operatingSystem': operatingSystem,
      'storageType': storageType,
      'ssdCount': ssdCount,
      'hdCount': hdCount,
      'imagePath': imagePath,
      'isComplete': isComplete,
      'userId': userId,
    };
  }

  factory Computer.fromMap(Map<String, dynamic> map, String id) {
    return Computer(
      id: id,
      name: map['name'] ?? '',
      processor: map['processor'] ?? '',
      ram: map['ram'] ?? '',
      gpu: map['gpu'] ?? '',
      powerSupply: map['powerSupply'],
      caseModel: map['caseModel'],
      motherboard: map['motherboard'],
      operatingSystem: map['operatingSystem'] ?? '',
      storageType: map['storageType'] ?? '',
      ssdCount: map['ssdCount'] ?? 0,
      hdCount: map['hdCount'] ?? 0,
      imagePath: map['imagePath'],
      isComplete: map['isComplete'] ?? false,
      userId: map['userId'],
    );
  }
}