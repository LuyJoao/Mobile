import 'package:flutter/material.dart';

class Computer {
  int? id;
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
    this.isComplete = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'isComplete': isComplete ? 1 : 0,
    };
  }

  factory Computer.fromMap(Map<String, dynamic> map) {
    return Computer(
      id: map['id'] as int?,
      name: map['name'] as String,
      processor: map['processor'] as String,
      ram: map['ram'] as String,
      gpu: map['gpu'] as String,
      powerSupply: map['powerSupply'] as String?,
      caseModel: map['caseModel'] as String?,
      motherboard: map['motherboard'] as String?,
      operatingSystem: map['operatingSystem'] as String,
      storageType: map['storageType'] as String,
      ssdCount: map['ssdCount'] as int,
      hdCount: map['hdCount'] as int,
      imagePath: map['imagePath'] as String?,
      isComplete: map['isComplete'] == 1,
    );
  }
}